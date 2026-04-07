---
layout: "post"
title: "数据流join"
subtitle: "大数据 / 实时计算 / Flink实时数据仓库"
date: "2025-04-10 16:01:03"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 实时计算
    - Flink实时数据仓库
categories:
    - 大数据
---

> 来源：`本机相关/03-大数据/01-实时计算/Flink实时数据仓库/数据流join.md`

两条流的全量 Join，SELECT * FROM A INNER JOIN B WHERE A.id = B.id；
 一句话定义
connect：
将两个数据流连接成一个 ConnectedStreams，允许共享状态和处理逻辑，但保留各自数据的独立性。
union：
将多个类型相同的数据流合并成一个 DataStream，数据混合后无区分。
broadcast：
将一个数据流广播到下游所有并行任务，通常用于配置数据或规则的分发




public class TwoStreamFullJoinExample {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.setParallelism(1);
        
        SingleOutputStreamOperator<Tuple3<String, String, Long>> stream1 = env.fromElements(
                Tuple3.of("a", "stream-1", 1000L),
                Tuple3.of("b", "stream-1", 2000L)
        )
                .assignTimestampsAndWatermarks(WatermarkStrategy.<Tuple3<String, String, Long>>forMonotonousTimestamps()
                        .withTimestampAssigner(new SerializableTimestampAssigner<Tuple3<String, String, Long>>() {
                            @Override
                            public long extractTimestamp(Tuple3<String, String, Long> t, long l) {
                                return t.f2;
                            }
                        })
                );
        
        SingleOutputStreamOperator<Tuple3<String, String, Long>> stream2 = env.fromElements(
                Tuple3.of("a", "stream-2", 3000L),
                Tuple3.of("b", "stream-2", 4000L)
        )
                .assignTimestampsAndWatermarks(WatermarkStrategy.<Tuple3<String, String, Long>>forMonotonousTimestamps()
                        .withTimestampAssigner(new SerializableTimestampAssigner<Tuple3<String, String, Long>>() {
                            @Override
                            public long extractTimestamp(Tuple3<String, String, Long> t, long l) {
                                return t.f2;
                            }
                        })
                );
        
        stream1.keyBy(r -> r.f0)
                .connect(stream2.keyBy(r -> r.f0))
                .process(new CoProcessFunction<Tuple3<String, String, Long>, Tuple3<String, String, Long>, String>() {
                    private ListState<Tuple3<String, String, Long>> stream1ListState;
                    private ListState<Tuple3<String, String, Long>> stream2ListState;

                    @Override
                    public void open(Configuration parameters) throws Exception {
                        super.open(parameters);
                        stream1ListState = getRuntimeContext().getListState(new ListStateDescriptor<Tuple3<String, String, Long>>("stream1-list", Types.TUPLE(Types.STRING, Types.STRING))
                        );
                        stream2ListState = getRuntimeContext().getListState(new ListStateDescriptor<Tuple3<String, String, Long>>("stream2-list", Types.TUPLE(Types.STRING, Types.STRING))
                        );
                    }

                    @Override
                    public void processElement1(Tuple3<String, String, Long> left, Context context, Collector<String> collector) throws Exception {
                        stream1ListState.add(left);
                        for (Tuple3<String, String, Long> right : stream2ListState.get()) {
                            collector.collect(left + " => " + right);
                        }
                    }

                    @Override
                    public void processElement2(Tuple3<String, String, Long> right, Context context, Collector<String> collector) throws Exception {
                        stream2ListState.add(right);
                        for (Tuple3<String, String, Long> left : stream1ListState.get()) {
                            collector.collect(left + " => " + right);
                        }
                    }
                })
                .print();
        env.execute();
    }
}

DataStream<String> stream = env.fromElements("A", "B", "C");

// 将流广播到下游所有任务
BroadcastStream<String> broadcastStream = stream.broadcast();

// 使用广播流
DataStream<String> result = broadcastStream
    .connect(nonBroadcastStream)
    .process(new BroadcastProcessFunction<String, Integer, String>() {
        @Override
        public void processElement(Integer value, ReadOnlyContext ctx, Collector<String> out) {
            // 使用广播数据
            String broadcastData = ctx.getBroadcastState(broadcastStateDescriptor).get("key");
            out.collect(value + " -> " + broadcastData);
        }

        @Override
        public void processBroadcastElement(String value, Context ctx, Collector<String> out) {
            // 更新广播状态
            ctx.getBroadcastState(broadcastStateDescriptor).put("key", value);
        }
    });
