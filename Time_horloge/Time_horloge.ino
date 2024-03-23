#include <WiFi.h>
#include <WebSocketsServer.h>

const char* ssid = "*";
const char* password = "12345678";

const int ledPin = 14;  
bool etatLed = false;

WebSocketsServer webSocket = WebSocketsServer(81);

void setup() {
  Serial.begin(115200);

  WiFi.mode(WIFI_AP);
  WiFi.softAP(ssid, password);

  Serial.println();
  Serial.print("Point d'accès WiFi créé: ");
  Serial.println(ssid);

  Serial.print("Adresse IP du point d'accès: ");
  Serial.println(WiFi.softAPIP());

  pinMode(ledPin, OUTPUT);  

  webSocket.begin();
  webSocket.onEvent(webSocketEvent);

}

void loop() {
  webSocket.loop();
}

void webSocketEvent(uint8_t num, WStype_t type, uint8_t* payload, size_t length) {
  switch (type) {
    case WStype_DISCONNECTED:
      Serial.printf("Client %d déconnecté\n", num);  
      break;
    case WStype_CONNECTED:
      {
        Serial.printf("Client %d connecté\n", num);
        if (etatLed == true) {
          webSocket.broadcastTXT("lamp on");
        } else if (etatLed == false) {
          webSocket.broadcastTXT("lamp off");
        }
      }
      break;
    case WStype_TEXT:
      Serial.printf("Client %d: %s\n", num, (char*)payload);  
      if (strcmp((char*)payload, "on") == 0) {
        digitalWrite(ledPin, HIGH);
        webSocket.broadcastTXT("lamp on");
        etatLed = true;  
      } else if (strcmp((char*)payload, "off") == 0) {
        webSocket.broadcastTXT("lamp off");
        digitalWrite(ledPin, LOW);  
        etatLed = false;
      }
      break;
    case WStype_BIN:
      Serial.println("Données binaires reçues, mais non traitées");
      break;
  }
}
