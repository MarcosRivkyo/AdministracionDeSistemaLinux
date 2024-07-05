import requests
import os
import datetime
import socket

def send_telegram_message(bot_token, chat_id, message):
    url = f"https://api.telegram.org/bot{bot_token}/sendMessage"
    payload = {
        'chat_id': chat_id,
        'text': message
    }
    response = requests.post(url, json=payload)
    
    if response.status_code == 200:
        print("Mensaje enviado correctamente via MarcoskyBot en Telegram")
    else:
        print("Error senviando el mensaje via Telegram. Status code:", response.status_code)

# Token del bot MarcoskyBot de Telegram
bot_token = "7144443313:AAHF1041HmtwCj0-_isVySVZclhU0B-sQcc"
# ID del chat al que enviara el mensaje 
chat_id = "729640352"
# Hora a la que se envia el mensaje
horaActual = datetime.datetime.now().strftime("%d-%m-%Y %H:%M:%S")
# Nombre del sistema iniciado
nombreSistema = socket.gethostname()
# Mensaje enviado
mensaje = f"El servidor DIA-server ha sido iniciado:\n{horaActual}\n{nombreSistema}"
# Llamada a la función para enviar el mensaje
send_telegram_message(bot_token, chat_id, mensaje)
