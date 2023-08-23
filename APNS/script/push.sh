
#Chandra_prod: 4da88ae0d8f513c9932c8f7af7ac5eb1488852756f3fc239d463c353674c2220
#Bhaskar_prod: c096099103a2d45abf285214cf18aebdbd7cdd960ceee5d5accfd60de44dae98
#Narasimha_prod: f64be63b25cd7854c5c2c6da4c73dc05791e60bb31ae72a9a54defb11eab5016
#venky_prod:ce200bea75366d708c65de830e75e8783c756fb6a0e5dda29ac4688919701647

#Narasimha_dev:  5ee983d4ee343fd099032c570a9ceedab1a24525fd6ea25b2745785aa1456554
#chandra_dev: 241fe8818fb01ae7d26ff242979fe5e15e8a91ebe94f0ace18c33fe0ff0ddb5a

TEAM_ID='DNHPH5E8K4'
TOKEN_KEY_FILE_NAME='/Users/chandra.sekhar/Desktop/APNS/certificates/AuthKey_9YY686YXCG.p8'
AUTH_KEY_ID='9YY686YXCG'
TOPIC='com.newsDistill.NewsDistillApp'
DEVICE_TOKEN='4da88ae0d8f513c9932c8f7af7ac5eb1488852756f3fc239d463c353674c2220'
APNS_HOST_NAME='api.push.apple.com'
#APNS_HOST_NAME='api.sandbox.push.apple.com'


#JSON_FILE='@/Users/chandra.sekhar/Desktop/APNS/apns_json/video_post.apns'

#JSON_FILE_ARRAY=(
#'@/Users/chandra.sekhar/Desktop/APNS/apns_json/reco_supported_types/video_mp4_98.apns' /
#'@/Users/chandra.sekhar/Desktop/APNS/apns_json/reco_supported_types/video_youtube_98.apns' /
#'@/Users/chandra.sekhar/Desktop/APNS/apns_json/reco_supported_types/news_99.apns' /
#'@/Users/chandra.sekhar/Desktop/APNS/apns_json/reco_supported_types/webview.apns' /
#'@/Users/chandra.sekhar/Desktop/APNS/apns_json/reco_supported_types/poll_94.apns'
#)
JSON_FILE_ARRAY=('@/Users/chandra.sekhar/Desktop/APNS/apns_json/reco_supported_types/news_99.apns')

for JSON_FILE in ${JSON_FILE_ARRAY[@]}
do
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
done

