---
layout: "post"
title: "python事件管理系统"
subtitle: "编程语言 / Python / Python"
date: "2026-03-29 14:08:07"
author: "XGuider"
header-img: "img/post-bg.jpg"
catalog: true
tags:
    - Python
categories:
    - 编程语言
---

> 来源：`本机相关/01-编程语言/02-Python/Python/python事件管理系统.md`

---
tags:
  - Python
  - 编程语言
  - 事件系统
  - 插件架构
created: 2024-01-01
updated: 2026-03-29
status: final
confidence: high
---

from enum import Enum
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

class EventAction(Enum):
    CONTINUE = 1
    BREAK = 2

class EventContext:
    def __init__(self, event, action=EventAction.CONTINUE):
        self.event = event
        self.action = action
        self.data = {}

    def is_break(self):
        return self.action == EventAction.BREAK

class Plugin:
    def __init__(self, name, enabled=True):
        self.name = name
        self.enabled = enabled

class PluginInstance:
    def __init__(self, handlers):
        self.handlers = handlers
=========================
class EventManager:
    def __init__(self):
        self.listening_plugins = {
            "user_join": ["welcome_plugin", "log_plugin"],
            "send_message": ["log_plugin", "reminder_plugin"],
            "set_reminder": ["reminder_plugin"]
        }
        self.plugins = {
            "welcome_plugin": Plugin("welcome_plugin", enabled=True),
            "log_plugin": Plugin("log_plugin", enabled=True),
            "reminder_plugin": Plugin("reminder_plugin", enabled=True)
        }
        self.instances = {
            "welcome_plugin": PluginInstance({"user_join": welcome_handler}),
            "log_plugin": PluginInstance({"user_join": log_join_handler, "send_message": log_message_handler}),
            "reminder_plugin": PluginInstance({"send_message": reminder_handler, "set_reminder": set_reminder_handler})
        }

    def emit_event(self, e_context, *args, **kwargs):
        if e_context.event in self.listening_plugins:
            for name in self.listening_plugins[e_context.event]:
                if self.plugins[name].enabled and e_context.action == EventAction.CONTINUE:
                    logger.debug("Plugin %s triggered by event %s" % (name, e_context.event))
                    instance = self.instances[name]
                    instance.handlers[e_context.event](e_context, *args, **kwargs)
                    if e_context.is_break():
                        e_context["breaked_by"] = name
                        logger.debug("Plugin %s breaked event %s" % (name, e_context.event))
        return e_context
=========================
def welcome_handler(e_context, *args, **kwargs):
    user = kwargs.get("user")
    print(f"Welcome, {user}!")

def log_join_handler(e_context, *args, **kwargs):
    user = kwargs.get("user")
    print(f"User {user} joined the chat.")

def log_message_handler(e_context, *args, **kwargs):
    user = kwargs.get("user")
    message = kwargs.get("message")
    print(f"Message from {user}: {message}")

def reminder_handler(e_context, *args, **kwargs):
    message = kwargs.get("message")
    print(f"Reminder: {message}")

def set_reminder_handler(e_context, *args, **kwargs):
    reminder_time = kwargs.get("time")
    reminder_message = kwargs.get("message")
    print(f"Reminder set for {reminder_time}: {reminder_message}")

==========================
# 创建事件管理器实例
event_manager = EventManager()

# 触发用户加入事件
e_context = EventContext(event="user_join")
event_manager.emit_event(e_context, user="Alice")
