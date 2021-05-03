"use-strict";
const functions = require("firebase-functions");
const admin = require('firebase-admin')
admin.initializeApp(functions.config().firebase);

// sendNotification with topic
// exports.sendNotification = functions.database.ref('bubble/{id}').onWrite(
//     ( event) => {
//         let title = event.after.child('title').val();
//         let content = event.after.child('content').val();

//         console.log(content)

//         const payload = {
//             notification: {
//                 title: title,
//                 body: content,
//             },
//             android: {
//                 notification: {
//                   sound: 'default',
//                   click_action: 'FLUTTER_NOTIFICATION_CLICK',
//                 },
//               },
//               apns: {
//                 payload: {
//                   aps: {
//                     badge: 1,
//                     sound: 'default'
//                   },
//                 },
//               },
//             topic: 'push_notification',
//         }
//         return admin.messaging().send(payload).then(function(response) {
//             console.log('Successfully sent message:', response);
//             return
//         }).catch(error => {
//             console.log('Error sending message:', error);
//             return
//         })
//     }
// )

exports.sendNotificationFCMToken = functions.database.ref('Notification/{id}').onWrite((event) => {
    let uid = event.after.child('idUser').val();
    let name = event.after.child('name').val();

    return admin.database().ref('UserDeviceToken/'+uid).once('value').then(snapshot => {
        const theToken = snapshot.child('tokent').val();

        console.log("TOKEN", name)

        const payload = {
            notification: {
                title: "DAY LA TITLE" + name,
                body: "DAY LA SUBTITLE",
            },
            token: theToken,
        }

        return admin.messaging().send(payload).then(response =>{
            console.log("Successfully sent message", response)
        }).catch(err =>{
            console.log("Error sending message",err)
        })
    })


    // const payload = {
    //     notification: {
    //         title: title,
    //         body: content,
    //     },
    //     android: {
    //         notification: {
    //             sound: 'default',
    //             click_action: 'FLUTTER_NOTIFICATION_CLICK',
    //         },
    //     },
    //     apns: {
    //         payload: {
    //             aps: {
    //                 badge: 1,
    //                 sound: 'default'
    //             },
    //         },
    //     },
    //     topic: 'push_notification',
    // }
    // return admin.messaging().send(payload)
})