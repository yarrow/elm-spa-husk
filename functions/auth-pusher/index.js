exports.handler = async function (event, context) {
    console.log("EVENT: \n" + JSON.stringify(event, null, 2))

    const query = event.queryStringParameters
    if (query.password !== process.env.PASSWORD) {
        return { statusCode: 403, body: 'Forbidden' }
    }

    const Pusher = require('pusher-js');
    const pusher = new Pusher({
        appId: process.env.PUSHER_APP_ID,
        key: process.env.PUSHER_KEY,
        secret: process.env.PUSHER_SECRET,
        cluster: process.env.PUSHER_CLUSTER,
        useTLS: false
    })

    const presenceData = {
        user_id: query.socket_id,
        user_info: { name: query.username }
    }
    const auth = pusher.authenticate(query.socket_id, query.channel_name, presenceData)
    return {
        statusCode: 200,
        headers: {
            "content-type": "application/json; charset=UTF-8",
            "access-control-allow-origin": "*",
            "access-control-expose-headers": "content-encoding,date,server,content-length"
        },
        body: JSON.stringify(auth)
    }
}
