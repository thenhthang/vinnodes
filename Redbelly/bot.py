from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes
from main import get_redbelly_status_html, get_diff_block
import os
import asyncio
import requests

# Telegram Bot Configuration
BOT_TOKEN = "YOUR TOKEN"
CHAT_ID = "YOUR ID"

async def hello(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    message = get_redbelly_status_html()
    await update.message.reply_text(
        f'Hello {update.effective_user.first_name}!\n\n{message}',
        parse_mode='HTML'
    )

# Gửi tin nhắn qua Bot
async def send_telegram_message(bot_app, message: str):
    await bot_app.bot.send_message(
        chat_id=CHAT_ID,
        text=message,
        parse_mode='HTML'
    )

# Hàm chạy nền mỗi 5 phút để kiểm tra node
async def monitor_status(bot_app):
    while True:
        result = get_diff_block()
        print(f"[monitor_status] Block diff result: {result}") 
        if isinstance(result, int) and abs(result) >5:
            message = get_redbelly_status_html()
            await send_telegram_message(bot_app, message)
        elif isinstance(result, str) and result.startswith("<b>Error"):
            await send_telegram_message(bot_app, result)

        await asyncio.sleep(5 * 60)  # Ngủ 5 phút

# Hàm được gọi sau khi bot khởi tạo xong
async def post_init(application):
    print("[monitor_status] Started!")  # <-- dòng debug khởi động
    application.create_task(monitor_status(application))

app = ApplicationBuilder().token(BOT_TOKEN).post_init(post_init).build()

app.add_handler(CommandHandler("status", hello))

# Bắt đầu polling
if __name__ == "__main__":
    print("Bot Started!")  # 
    app.run_polling()
# app.run_polling()