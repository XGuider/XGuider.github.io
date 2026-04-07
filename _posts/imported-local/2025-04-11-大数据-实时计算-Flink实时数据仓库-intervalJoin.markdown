---
layout: "post"
title: "intervalJoin"
subtitle: "大数据 / 实时计算 / Flink实时数据仓库"
date: "2025-04-11 09:55:18"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - 实时计算
    - Flink实时数据仓库
categories:
    - 大数据
---

> 来源：`本机相关/03-大数据/01-实时计算/Flink实时数据仓库/intervalJoin.md`

################ 订单和支付 ################ 
import org.apache.flink.api.common.eventtime.*;
import org.apache.flink.api.common.functions.*;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.streaming.api.datastream.*;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.co.ProcessJoinFunction;
import org.apache.flink.streaming.api.windowing.time.Time;
import org.apache.flink.util.Collector;
import org.apache.flink.util.OutputTag;

import java.time.Duration;

public class OrderPaymentTimeoutMonitor {
    // 定义输入事件POJO类
    public static class OrderEvent {
        public String orderId;
        public String userId;
        public long eventTime; // 事件时间戳（毫秒）
        // 其他字段...
    }
    public static class PaymentEvent {
        public String orderId;
        public double amount;
        public long eventTime; // 事件时间戳（毫秒）
        // 其他字段...
    }

    public static void main(String[] args) throws Exception {
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        
        // 1. 设置事件时间语义和水位线
        env.setStreamTimeCharacteristic(TimeCharacteristic.EventTime);
        env.getConfig().setAutoWatermarkInterval(1000); // 每秒生成水位线

        // 2. 模拟数据源（生产环境替换为Kafka等）
        DataStream<OrderEvent> orders = env.addSource(new OrderEventSource())
            .assignTimestampsAndWatermarks(new OrderWatermarkStrategy());

        DataStream<PaymentEvent> payments = env.addSource(new PaymentEventSource())
            .assignTimestampsAndWatermarks(new PaymentWatermarkStrategy());

        // 3. 定义超时侧输出流标签
        OutputTag<OrderEvent> timeoutTag = new OutputTag<>("timeout-orders"){};

        // 4. 核心逻辑：IntervalJoin关联订单和支付事件
        SingleOutputStreamOperator<Tuple2<OrderEvent, PaymentEvent>> processedStream = orders
            .keyBy(order -> order.orderId)
            .intervalJoin(payments.keyBy(payment -> payment.orderId))
            .between(Time.minutes(0), Time.minutes(30)) // 30分钟超时窗口
            .sideOutputLateData(timeoutTag) // 超时订单输出到侧流
            .process(new ProcessJoinFunction<OrderEvent, PaymentEvent, Tuple2<OrderEvent, PaymentEvent>>() {
                @Override
                public void processElement(
                    OrderEvent order,
                    PaymentEvent payment,
                    Context ctx,
                    Collector<Tuple2<OrderEvent, PaymentEvent>> out) {
                    
                    // 正常支付处理
                    out.collect(Tuple2.of(order, payment));
                }
            });

        // 5. 处理超时订单（侧输出流）
        DataStream<String> timeoutAlerts = processedStream
            .getSideOutput(timeoutTag)
            .map(new MapFunction<OrderEvent, String>() {
                @Override
                public String map(OrderEvent order) throws Exception {
                    return String.format(
                        "[超时告警] 订单ID: %s, 用户ID: %s, 创建时间: %s 超过30分钟未支付！",
                        order.orderId, order.userId, new java.util.Date(order.eventTime)
                    );
                }
            });

        // 6. 处理正常支付订单
        DataStream<String> paymentSuccess = processedStream
            .map(new MapFunction<Tuple2<OrderEvent, PaymentEvent>, String>() {
                @Override
                public String map(Tuple2<OrderEvent, PaymentEvent> value) throws Exception {
                    return String.format(
                        "[支付成功] 订单ID: %s, 金额: %.2f, 支付延迟: %d秒",
                        value.f0.orderId,
                        value.f1.amount,
                        (value.f1.eventTime - value.f0.eventTime) / 1000
                    );
                }
            });

        // 7. 输出结果（生产环境可写入Kafka/数据库等）
        paymentSuccess.print("支付成功");
        timeoutAlerts.print("超时告警");

        env.execute("Order Payment Timeout Monitoring");
    }

    // 自定义水位线策略（处理乱序）
    public static class OrderWatermarkStrategy implements WatermarkStrategy<OrderEvent> {
        @Override
        public WatermarkGenerator<OrderEvent> createWatermarkGenerator(WatermarkGeneratorSupplier.Context context) {
            return new BoundedOutOfOrdernessWatermarks<>(Duration.ofSeconds(5)); // 允许5秒乱序
        }

        @Override
        public TimestampAssigner<OrderEvent> createTimestampAssigner(TimestampAssignerSupplier.Context context) {
            return (event, timestamp) -> event.eventTime;
        }
    }

    // 支付事件水位线策略（可与订单不同）
    public static class PaymentWatermarkStrategy implements WatermarkStrategy<PaymentEvent> {
        @Override
        public WatermarkGenerator<PaymentEvent> createWatermarkGenerator(WatermarkGeneratorSupplier.Context context) {
            return new BoundedOutOfOrdernessWatermarks<>(Duration.ofSeconds(10)); // 支付事件乱序更大
        }

        @Override
        public TimestampAssigner<PaymentEvent> createTimestampAssigner(TimestampAssignerSupplier.Context context) {
            return (event, timestamp) -> event.eventTime;
        }
    }

    // 模拟数据源（生产环境替换为真实Source）
    public static class OrderEventSource implements SourceFunction<OrderEvent> {
        @Override
        public void run(SourceContext<OrderEvent> ctx) throws Exception {
            // 模拟订单事件...
        }

        @Override
        public void cancel() {}
    }

    public static class PaymentEventSource implements SourceFunction<PaymentEvent> {
        @Override
        public void run(SourceContext<PaymentEvent> ctx) throws Exception {
            // 模拟支付事件...
        }

        @Override
        public void cancel() {}
    }
}
################ 订单宽表-订单和订单明细关联 ################ 
import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import com.alibaba.fastjson.JSONObject;
import com.zhangbao.gmall.realtime.bean.OrderDetail;
import com.zhangbao.gmall.realtime.bean.OrderInfo;
import com.zhangbao.gmall.realtime.bean.OrderWide;
import com.zhangbao.gmall.realtime.utils.MyKafkaUtil;
import org.apache.flink.api.common.eventtime.SerializableTimestampAssigner;
import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.datastream.KeyedStream;
import org.apache.flink.streaming.api.datastream.SingleOutputStreamOperator;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.co.ProcessJoinFunction;
import org.apache.flink.streaming.api.windowing.time.Time;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;
import org.apache.flink.util.Collector;
import java.time.Duration;
public class OrderWideApp {
    public static void main(String[] args) {
        //webui模式，需要添加pom依赖
        StreamExecutionEnvironment env = StreamExecutionEnvironment.createLocalEnvironmentWithWebUI(new Configuration());
//        StreamExecutionEnvironment env1 = StreamExecutionEnvironment.createLocalEnvironment();
        //设置并行度
        env.setParallelism(4);
        //设置检查点
//        env.enableCheckpointing(5000, CheckpointingMode.EXACTLY_ONCE);
//        env.getCheckpointConfig().setCheckpointTimeout(60000);
//        env.setStateBackend(new FsStateBackend("hdfs://hadoop101:9000/gmall/flink/checkpoint/uniqueVisit"));
//        //指定哪个用户读取hdfs文件
//        System.setProperty("HADOOP_USER_NAME","zhangbao");

        //从kafka的dwd主题获取订单和订单详情
        String orderInfoTopic = "dwd_order_info";
        String orderDetailTopic = "dwd_order_detail";
        String orderWideTopic = "dwm_order_wide";
        String orderWideGroup = "order_wide_group";
        //订单数据
        FlinkKafkaConsumer<String> orderInfoSource = MyKafkaUtil.getKafkaSource(orderInfoTopic, orderWideGroup);
        DataStreamSource<String> orderInfoDs = env.addSource(orderInfoSource);
        //订单详情数据
        FlinkKafkaConsumer<String> orderDetailSource = MyKafkaUtil.getKafkaSource(orderDetailTopic, orderWideGroup);
        DataStreamSource<String> orderDetailDs = env.addSource(orderDetailSource);
        //对订单数据进行转换
        SingleOutputStreamOperator<OrderInfo> orderInfoObjDs = orderInfoDs.map(new RichMapFunction<String, OrderInfo>() {
            @Override
            public OrderInfo map(String jsonStr) throws Exception {
                System.out.println("order info str >>> "+jsonStr);
                OrderInfo orderInfo = JSONObject.parseObject(jsonStr, OrderInfo.class);
                DateTime createTime = DateUtil.parse(orderInfo.getCreate_time(), "yyyy-MM-dd HH:mm:ss");
                orderInfo.setCreate_ts(createTime.getTime());
                return orderInfo;
            }
        });
        //对订单明细数据进行转换
        SingleOutputStreamOperator<OrderDetail> orderDetailObjDs = orderDetailDs.map(new RichMapFunction<String, OrderDetail>() {
            @Override
            public OrderDetail map(String jsonStr) throws Exception {
                System.out.println("order detail str >>> "+jsonStr);
                OrderDetail orderDetail = JSONObject.parseObject(jsonStr, OrderDetail.class);
                DateTime createTime = DateUtil.parse(orderDetail.getCreate_time(), "yyyy-MM-dd HH:mm:ss");
                orderDetail.setCreate_ts(createTime.getTime());
                return orderDetail;
            }
        });
        orderInfoObjDs.print("order info >>>");
        orderDetailObjDs.print("order detail >>>");
        //指定事件时间字段
        //订单事件时间字段
        SingleOutputStreamOperator<OrderInfo> orderInfoWithTsDs = orderInfoObjDs.assignTimestampsAndWatermarks(
                WatermarkStrategy
                        .<OrderInfo>forBoundedOutOfOrderness(Duration.ofSeconds(3))
                        .withTimestampAssigner(new SerializableTimestampAssigner<OrderInfo>() {
                            @Override
                            public long extractTimestamp(OrderInfo orderInfo, long l) {
                                return orderInfo.getCreate_ts();
                            }
                        })
        );
        //订单明细指定事件事件字段
        SingleOutputStreamOperator<OrderDetail> orderDetailWithTsDs = orderDetailObjDs.assignTimestampsAndWatermarks(
                WatermarkStrategy.<OrderDetail>forBoundedOutOfOrderness(Duration.ofSeconds(3))
                        .withTimestampAssigner(new SerializableTimestampAssigner<OrderDetail>() {
                            @Override
                            public long extractTimestamp(OrderDetail orderDetail, long l) {
                                return orderDetail.getCreate_ts();
                            }
                        })
        );
        //分组
        KeyedStream<OrderInfo, Long> orderInfoKeysDs = orderInfoWithTsDs.keyBy(OrderInfo::getId);
        KeyedStream<OrderDetail, Long> orderDetailKeysDs = orderDetailWithTsDs.keyBy(OrderDetail::getOrder_id);
        /**
         * interval-join
         * https://nightlies.apache.org/flink/flink-docs-release-1.14/docs/dev/datastream/operators/joining/#interval-join
         */
        SingleOutputStreamOperator<OrderWide> orderWideDs = orderInfoKeysDs.intervalJoin(orderDetailKeysDs)
                .between(Time.milliseconds(-5), Time.milliseconds(5))
                .process(new ProcessJoinFunction<OrderInfo, OrderDetail, OrderWide>() {
                    @Override
                    public void processElement(OrderInfo orderInfo, OrderDetail orderDetail, ProcessJoinFunction<OrderInfo, OrderDetail, OrderWide>.Context context, Collector<OrderWide> out) throws Exception {
                        out.collect(new OrderWide(orderInfo, orderDetail));
                    }
                });
        orderWideDs.print("order wide ds >>>");
        try {
            env.execute("order wide task");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
