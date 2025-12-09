#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define SPEAKER   13
#define BTN_FIRE  12
#define BTN_RIGHT 14
#define BTN_DOWN  27
#define BTN_UP    26
#define BTN_LEFT  25
#define LED_PIN   33

void playMelody(const String& name);

// === UUID ===
#define SERVICE_UUID        "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_UUID "abcd1234-abcd-1234-abcd-1234567890ab"

// BLE
BLECharacteristic* pCharacteristic = nullptr;
volatile bool deviceConnected = false;

// Flags
volatile bool hitRequested     = false;
volatile bool startRequested   = false;
volatile bool finishRequested  = false;

// Buttons
bool lastUp = HIGH, lastDown = HIGH, lastLeft = HIGH, lastRight = HIGH, lastFire = HIGH;

// === SERVER CALLBACKS ===
class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) override {
    deviceConnected = true;
    startRequested = true;
    Serial.println("📲 Connected");
  }

  void onDisconnect(BLEServer* pServer) override {
    deviceConnected = false;
    finishRequested = true;
    Serial.println("📴 Disconnected");

    BLEDevice::startAdvertising();
  }
};

class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic* pChar) override {
    String rxValue = pChar->getValue();
    Serial.print("📥 RX: ");
    for (size_t i = 0; i < rxValue.length(); i++) {
        Serial.print((int)rxValue[i]); // печатаем числовое значение байта
        Serial.print(" ");
    }
    Serial.println();

    if (rxValue.length() > 0 && rxValue[0] == 1) {
        hitRequested = true;
    } else if (rxValue.length() > 0 && rxValue[0] == 0) {
        digitalWrite(LED_PIN, LOW);
        pChar->setValue("LED OFF");
    } else {
        Serial.println("⚠️ Неизвестная команда");
        pChar->setValue("Unknown command");
    }

    pChar->notify();
  }
};

// === SEND MESSAGE ===
void sendBLEMessage(const String& msg) {
  if (!deviceConnected || pCharacteristic == nullptr) return;

  pCharacteristic->setValue(msg.c_str());
  pCharacteristic->notify();

  Serial.print("📤 TX: ");
  Serial.println(msg);
}

// === SETUP ===
void setup() {
  Serial.begin(115200);

  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  pinMode(BTN_UP, INPUT_PULLUP);
  pinMode(BTN_DOWN, INPUT_PULLUP);
  pinMode(BTN_LEFT, INPUT_PULLUP);
  pinMode(BTN_RIGHT, INPUT_PULLUP);
  pinMode(BTN_FIRE, INPUT_PULLUP);

  BLEDevice::init("OTUS_SEABATTLE");

  BLEServer* pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService* pService = pServer->createService(SERVICE_UUID);

  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ |
    BLECharacteristic::PROPERTY_WRITE |
    BLECharacteristic::PROPERTY_NOTIFY
  );

  pCharacteristic->setCallbacks(new MyCallbacks());
  pCharacteristic->addDescriptor(new BLE2902());
  pCharacteristic->setValue("Ready!");

  pService->start();

  BLEAdvertising *advertising = BLEDevice::getAdvertising();
  advertising->addServiceUUID(SERVICE_UUID);
  advertising->setScanResponse(true);
  advertising->setMinPreferred(0x06);
  advertising->setMinPreferred(0x12);
  advertising->start();

  Serial.println("🚀 BLE Started");
}

// === LOOP ===
void loop() {

  // BLE Events
  if (startRequested) {
    startRequested = false;
    playMelody("start");
  }

  if (finishRequested) {
    finishRequested = false;
    playMelody("finish");
  }

  if (hitRequested) {
    hitRequested = false;
    digitalWrite(LED_PIN, HIGH);
    delay(200);
    digitalWrite(LED_PIN, LOW);
    playMelody("hit");
  }

  // Buttons
  bool up = digitalRead(BTN_UP);
  bool down = digitalRead(BTN_DOWN);
  bool left = digitalRead(BTN_LEFT);
  bool right = digitalRead(BTN_RIGHT);
  bool fire = digitalRead(BTN_FIRE);

  if (up == LOW && lastUp == HIGH) {
    playMelody("beep");
    sendBLEMessage("up");
  }
  if (down == LOW && lastDown == HIGH) {
    playMelody("beep");
    sendBLEMessage("down");
  }
  if (left == LOW && lastLeft == HIGH) {
    playMelody("beep");
    sendBLEMessage("left");
  }
  if (right == LOW && lastRight == HIGH) {
    playMelody("beep");
    sendBLEMessage("right");
  }
  if (fire == LOW && lastFire == HIGH) {
    playMelody("beep");
    sendBLEMessage("fire");
  }

  lastUp = up;
  lastDown = down;
  lastLeft = left;
  lastRight = right;
  lastFire = fire;

  delay(30);
}

// === SOUND ===
void playMelody(const String& name) {

  static bool initialized = false;
  if (!initialized) {
    tone(SPEAKER, 1);
    delay(5);
    noTone(SPEAKER);
    initialized = true;
  }

  if (name == "beep") {
    tone(SPEAKER, 1200); delay(120); noTone(SPEAKER);
  }
  else if (name == "start") {
    tone(SPEAKER, 800); delay(150);
    tone(SPEAKER, 1200); delay(150);
    tone(SPEAKER, 1600); delay(150);
    noTone(SPEAKER);
  }
  else if (name == "finish") {
    tone(SPEAKER, 1600); delay(150);
    tone(SPEAKER, 1200); delay(150);
    tone(SPEAKER, 800); delay(150);
    noTone(SPEAKER);
  }
  else if (name == "hit") {
    tone(SPEAKER, 600); delay(200); noTone(SPEAKER);
  }
  else {
    Serial.println("⚠️ Unknown melody");
  }
}
