# 航衡：DeepSeek 本地源码版

这是可编辑、可在你电脑运行的聊天助手。前端保留简洁的对话界面；后端真正请求 DeepSeek API，并带上赛事模拟数据与规则。无需 OpenAI 账户或插件。

## 1. 运行（Mac）

需要 Python 3.9 或以上版本。终端输入 `python3 --version` 检查；如果没有，从 https://www.python.org/downloads/ 安装 Python。

1. 解压本文件夹，可用 VS Code 打开整个文件夹。
2. 复制 `.env.example` 为 `.env`。隐藏文件在 Mac Finder 可按 Command + Shift + . 显示。
3. 用 VS Code 编辑 `.env`，把 `paste_your_deepseek_api_key_here` 换成自己的密钥并保存。不要把密钥放进 public、发到聊天或提交 Git。
4. 在这个文件夹打开终端，运行：

```bash
python3 server.py
```

5. 浏览器打开 **http://localhost:8000**。保持终端窗口运行，按 Ctrl+C 停止。

也可以尝试双击 `start-mac.command`。如果无法双击、权限不足或被系统拦截，直接用上面的终端命令运行即可，不需要关闭系统安全保护。

在终端内复制配置文件可用：

```bash
cp .env.example .env
```

这一步只需第一次执行，不要重复覆盖已经填好密钥的 `.env`。

## 2. Windows

安装 Python 3.9+，复制 `.env.example` 为 `.env` 并填写密钥。双击 `start-windows.bat`，或在此目录运行：

```powershell
py -3 server.py
```

然后打开 http://localhost:8000 。无需 pip 或 npm 安装任何依赖。

## 3. 配置示例

```dotenv
DEEPSEEK_API_KEY=在你自己的电脑上填写密钥
DEEPSEEK_MODEL=deepseek-flash
PORT=8000
```

修改 `.env` 后停止并重新启动服务。环境变量优先于 `.env`，如你此前设置过同名系统变量，请确保一致。修改提示词文件后下一条请求即可生效；修改网页文件后刷新页面；修改 server.py 后重启。

截至2026-10-24，已查阅的 DeepSeek 官方文档示例使用 `deepseek-flash` 和 `deepseek-v4-pro`。以你的账户实际支持的模型ID为准，填入 DEEPSEEK_MODEL；不要根据旧教程猜测别名。请求发送至官方 `https://api.deepseek.com/chat/completions`，使用Bearer密钥。本版默认关闭thinking并限制每次生成至2400 tokens。

官方文档：https://api-docs.deepseek.com/
接口文档：https://api-docs.deepseek.com/api/create-chat-completion/

## 4. 想改什么，打开哪个文件？

| 想修改的内容 | 文件 |
|---|---|
| 标题、颜色、字体、布局 | public/index.html（内含CSS） |
| 示例问题、发送逻辑、对话保存 | public/app.js |
| 助手角色、回复风格、引用与人工审批要求 | system_prompt.txt |
| 模型与密钥、端口 | .env，仅在本地创建 |
| API调用、数据检索、长度限制 | server.py |
| 机场和事件、规则数据 | data/source-data.json |

用 VS Code 或其他纯文本编辑器修改。不要用 Word 编辑源码。

## 5. 数据如何进入模型

后端读取原 Excel 的逐行JSON提取，覆盖全部工作表。提问中匹配到机场时，加入该机场24个月历史、年度规模与天气数据；同时提供5个模拟事件、12条规则与3条赛事模拟反馈。新问题明确指定机场时优先使用新机场，未指定时参考会话中曾提到的机场。未知机场没有自身历史，模型应承认缺口。

这不是重新训练模型。每次调用把参考数据和最近的对话一起发送给DeepSeek。最多30条消息、总计60000字符；更长时请保存后新建对话。API按你的DeepSeek账户计费。本机开启服务并不会调用API，发送问题才会调用。

## 6. 隐私、权限与能力限制

- API Key 只由本机Python读取，浏览器拿不到；后端只公开首页、app.js和两个API接口，不能读取.env或服务器源码。
- 对话及相关机场资料会发送至DeepSeek服务；请勿输入真实旅客或员工资料。常见PII正则仅为有限拦截，不能保证完整脱敏。
- 对话存放在页面内存中，刷新或关闭即丢失；“保存对话”会下载到你自己的电脑。本地服务不记录聊天日志。
- 原资料全部为赛事模拟，不是真实天气或航班状态。没有联网搜索或航空业务执行接口。
- 风险与审批约束通过系统提示词和数据提供给模型，不是经过形式验证的强制规则引擎。模型仍可能算错、漏引或生成错误结论，所有输出需人工核对；不能把先前规则原型的34项测试通过率当作本版LLM准确率。
- 这是仅绑定127.0.0.1的本机演示，不是多人生产服务。不要直接把它暴露到公网。公开部署需要另行增加身份验证、限流及成本控制。
- 代码中保留了全部源数据供你编辑；不要把本地.env一起打包分享。

## 7. 常见问题

- 打开HTML却不能聊天：必须启动 server.py，然后访问 http://localhost:8000，不是双击HTML。
- 缺少密钥：确认文件名是 `.env`，不是 `.env.txt`，位置与 server.py 相同，填好后重启。
- 401：密钥无效、空格或已失效。不要通过截图或聊天展示密钥。
- 402：余额不足。404：核对模型名称。429：稍后再试。
- 连接失败/超时：检查当前电脑能否连接DeepSeek API。系统不会在失败时偷偷切换成规则回答。
- 端口被占用：将 `.env` 的 PORT 改为8001，重启后打开 http://localhost:8001。
- 有系统代理环境变量时：Python可能按系统代理设置连接DeepSeek，按你自己的网络配置处理。

## 8. 验证范围

运行 `python3 -m unittest -v test_server.py` 可执行无密钥测试。测试以模拟HTTP返回检查请求格式、上下文检索、正文解析、敏感文件不可访问与错误处理，不会联网或扣费。

制作时没有用户的DeepSeek密钥，未执行真实付费调用，也没有验证模型回答质量。首次运行请发送一个简单问题，观察页面是否显示模型响应，再用赛事的新事件、冲突、人工否决及禁止自动取消等情境做实际验收。
