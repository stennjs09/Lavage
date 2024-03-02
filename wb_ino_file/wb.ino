#include <WiFi.h>
#include <ArduinoWebsockets.h>
using namespace websockets;

WebsocketsClient socket;
const char* websocketServer = "ws://192.168.43.157:8096";
boolean connected = false;

const char* ssid = "F16";
const char* password = "123456789";

const int ledPin = 2;
const int relayPin = 32;

unsigned long previousMillisWiFi = 0;
const long intervalWiFi = 500000;

unsigned long previousMillis = 0;
const long interval = 1000;

int countdownTime = 0;

enum State {
  IDLE,
  COUNTDOWN,
};

State currentState = IDLE;

void setup() {
  Serial.begin(115200);
  WiFi.setSleep(false);
  connectWiFi();
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW);

  socket.onMessage(handleMessage);
  socket.onEvent(handleEvent);
}

void loop() {

  unsigned long currentMillisWiFi = millis();
  if (currentMillisWiFi - previousMillisWiFi >= intervalWiFi) {
    previousMillisWiFi = currentMillisWiFi;
    socket.close();
  }

  if (WiFi.status() != WL_CONNECTED) {
    connectWiFi();
  }

  try {
    socket.poll();

    unsigned long currentMillis = millis();

    if (!connected) {
      Serial.println("Connecting to WebSocket server");
      digitalWrite(ledPin, LOW);
      connectToWebSocket();
    } else {
      digitalWrite(ledPin, HIGH);
    }

    switch (currentState) {
      case IDLE:
        // Attendre un nouveau message
        break;

      case COUNTDOWN:
        if (currentMillis - previousMillis >= interval) {
          previousMillis = currentMillis;
          // Mettre à jour le compte à rebours ou effectuer d'autres actions périodiques

          updateCountdown();
        }
        break;
    }
  } catch (...) {
    Serial.println("Exception caught. Rebooting...");
    ESP.restart();  // Redémarrer l'appareil en cas d'exception
  }
}

void updateCountdown() {
  countdownTime--;
  if (countdownTime >= 0) {
    if (countdownTime % 60 == 0) {
      socket.send("galana/lavage/" + String(countdownTime / 60) + "/ok");
    }
  } else {
    // Fin du compte à rebours
    digitalWrite(relayPin, LOW);
    socket.send("relay turned off");
    currentState = IDLE;  // Revenir à l'état IDLE
  }
}

void handleMessage(WebsocketsMessage message) {
  String data = message.data();
  Serial.println(String(data));

  if (data == "galana.lavage.on") {
    digitalWrite(relayPin, HIGH);
    socket.send("relay turned On permanently");
  } else if (data == "galana.lavage.off") {
    countdownTime = 0;
    digitalWrite(relayPin, LOW);
    socket.send("relay turned off");
  } else if (data == "galana.lavage.temps") {
    socket.send("galana.lavage." + String(int(countdownTime / 60)) + "min");
  } else if (data == "galana.lavage.?") {
    socket.send("galana.lavage.yes?");
  } else {
    int splitIndex1 = data.indexOf('/');

    if (splitIndex1 != -1) {
      String part1 = data.substring(0, splitIndex1);
      String part2 = data.substring(splitIndex1 + 1);

      int splitIndex2 = part2.indexOf('/');
      if (splitIndex2 != -1) {
        String espName = part2.substring(0,splitIndex2);
        String time = part2.substring(splitIndex2 + 1);

        int newCountdownTime = 60 * (time.toInt());

        if (espName == "lavage" && newCountdownTime > 0) {
          digitalWrite(relayPin, HIGH);
          socket.send("galana/lavage/" + time + "/ok");

          // Initialiser les variables de compte à rebours
          countdownTime = newCountdownTime;
          currentState = COUNTDOWN;
          previousMillis = millis();

        } else {
          Serial.println(data +" X");
        }

      }
    }
  }
}

void handleEvent(WebsocketsEvent event, WSInterfaceString data) {
  switch (event) {
    case WebsocketsEvent::ConnectionOpened:
      Serial.println("WebSocket connection established");
      connected = true;
      break;
    case WebsocketsEvent::ConnectionClosed:
      Serial.println("WebSocket connection closed");
      connected = false;
      // Réessayer la connexion en cas de fermeture inattendue
      connectToWebSocket();
      break;
    case WebsocketsEvent::GotPing:
      Serial.println("Received ping");
      break;
    case WebsocketsEvent::GotPong:
      Serial.println("Received pong");
      break;
    default:
      break;
  }
}

void connectToWebSocket() {
  connected = socket.connect(websocketServer);
  if (connected) {
    Serial.println("Connected");
  } else {
    Serial.println("Connection failed.");
    // Gérer l'échec de connexion de manière appropriée
    handleConnectionFailure();
  }
}

void connectWiFi() {
  WiFi.mode(WIFI_OFF);
  delay(5000);
  WiFi.mode(WIFI_STA);
  digitalWrite(ledPin, LOW);

  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi");

  unsigned long startAttemptTime = millis();

  while (WiFi.status() != WL_CONNECTED) {
    if (millis() - startAttemptTime > 10000) {
      // Gérer l'échec de connexion WiFi après un certain temps
      handleWiFiConnectionFailure();
    }
    delay(500);
    Serial.print(".");
  }

  Serial.print("connected to : ");
  Serial.println(ssid);
  connectToWebSocket();
}

void handleConnectionFailure() {
  Serial.println("WebSocket connection failed. Reconnecting...");
  connectToWebSocket();  // Réessayer la connexion WebSocket
}

void handleWiFiConnectionFailure() {
  Serial.println("WiFi connection failed. Reconnecting...");
  connectWiFi();  // Réessayer la connexion WiFi
}
