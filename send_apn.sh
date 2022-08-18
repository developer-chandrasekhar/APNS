#Team id: Will be availabe at apple developer account
TEAM_ID=..... # ex: 'ABHPH5E8K4'
#TOKEN_KEY: Will be generated from apple developer accounts -> keys section
TOKEN_KEY_FILE_NAME=....  #ex:'/Users/usrname/Desktop/Certificates/Apns/AuthKey_ABY676YXCK.p8'
#AUTH_KEY_ID: Will be generated from apple developer accounts -> keys section
AUTH_KEY_ID=.... #ex: ABY676YXCK
#TOPIC: Your app bundle id
TOPIC=... #ex: 'com.org.app'
#DEVICE_TOKEN: You will get it from xcode
DEVICE_TOKEN=.... #ex: 'kdc19b1ff3f34ceffbd9cf698e5f286cb538a93b22853a7fb8abec3bb70180bu'
#APNS_HOST_NAME:
#    Sandbox: 'api.sandbox.push.apple.com'
#    Production: 'api.push.apple.com'

APNS_HOST_NAME='api.sandbox.push.apple.com'
#JSON_FILE: which you can create
JSON_FILE='@/Users/chandra.sekhar/Desktop/vibe_video_t.apns'

JWT_ISSUE_TIME=$(date +%s)
JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"
JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

curl -v \
--header "apns-topic: $TOPIC" \
--header "apns-push-type: alert" \
--header "authorization: bearer $AUTHENTICATION_TOKEN" \
--http2 https://${APNS_HOST_NAME}/3/device/${DEVICE_TOKEN} \
--data-binary $JSON_FILE
