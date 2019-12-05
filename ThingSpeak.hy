(import http.client urllib.parse)

(defclass ThingSpeak [object]
  (defn --init-- [self api-token]
    (setv self.api-token api-token))

  (defn connect [self &optional [host "api.thingspeak.com"] [context None]]
    (setv self.conn (http.client.HTTPSConnection host :context context))
    self.conn)

  (defn disconnect [self]
    (.close self.conn))

  (defn send-data [self data &optional [method "GET"]]
    (setv url (.format "/update?api_key={}&field1={}" self.api-token data))
    (.request self.conn :method method :url url)
    (setv response (.getresponse self.conn))

    (if (= 2 (// (int response.status) 100))
        (response.read)
        response.reason)))
