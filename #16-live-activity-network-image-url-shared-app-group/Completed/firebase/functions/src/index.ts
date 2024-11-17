const fs = require('fs');
const jwt = require('jsonwebtoken');
const http2 = require('node:http2');

import { onDocumentCreated, onDocumentUpdated, onDocumentDeleted } from 'firebase-functions/v2/firestore';
import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const teamID = "YOUR_TEAM_ID";
const keyID = "YOUR_KEY_ID";
const p8FilePath = `./AuthKey_${keyID}.p8`;
const bundleID = "YOUR_BUNDLE_ID";

initializeApp();
const db = getFirestore();


exports.createFunction = onDocumentCreated("elections/{electionId}", async (event) => {
    const electionId = event.params.electionId;
    try {
        const channelId = await createChannel();
        const electionRef = db.collection('elections').doc(electionId);
        await electionRef.update({ channelId: channelId });
        console.log(`Successfully updated channelId for election ${electionId}`);    
    } catch(error) {
        console.error(`Error updating channelId for election ${electionId}: `, error);
    }
});

exports.updateFunction = onDocumentUpdated("elections/{electionId}", async (event) => {
    const _election = event.data?.after.data()
    if (_election === null) {
        return;
    }
    const election = _election!;
    console.log(election);

    const channelId = election.channelId;
    const date = new Date();
    const unixTimestamp = Math.floor(date.getTime() / 1000);

    const json = {
        "aps": {
            "timestamp": unixTimestamp,
            "event": "update",    
            "content-state": {
                "aName": election.aName,
                "aCount": election.aCount,
                "aPercent": election.aPercent,
                "bName": election.bName,
                "bCount": election.bCount,
                "bPercent": election.bPercent,
                "aImageName": election.aImageName,
                "bImageName": election.bImageName
            }
        }
    }
    publishToApns(channelId, json);
});

exports.deleteFunction = onDocumentDeleted("elections/{electionId}", async (event) => {
    const _election = event.data?.data()
    const electionId = event.params.electionId;
    if (_election === null) {
        return;
    }
    const election = _election!;
    try {
        await deleteChannel(election.channelId);
        console.log(`Successfully deleted channelId for election ${electionId}`);    
    } catch(error) {
        console.error(`Error deleting channelId for election ${electionId}: `, error);
    }
});

function getAPNSAuthToken(): string {
    const privateKey = fs.readFileSync(p8FilePath);
    const secondsSinceEpoch = Math.round(Date.now() / 1000);
    const payload = {
        iss: teamID,
        iat: secondsSinceEpoch
    };
    const finalEncryptToken = jwt.sign(payload, privateKey, {algorithm: 'ES256', keyid: keyID});
    return finalEncryptToken;
}

function createChannel(): Promise<string> {
    return new Promise((resolve, reject) => {
        const session = http2.connect('https://api-manage-broadcast.sandbox.push.apple.com:2195');
        session.on('error', (err: any) => {
            console.log("Session Error", err);
            reject(err);
        })
        const req = session.request(
            {
                ":method": "POST",
                ":path": "/1/apps/" + bundleID + "/channels",
                "authorization": "bearer " + getAPNSAuthToken(),
                "Content-Type": 'application/json',
            }
        );

        req.on('response', (headers: any) => {
            let status = headers[http2.constants.HTTP2_HEADER_STATUS] 
            console.log(status);
            if (status === 201) {
                resolve(headers['apns-channel-id']);
                return;
            }
            reject(status);
        });

        req.setEncoding('utf8');        
        req.on('end', () => {
            session.close();
        });
        req.end(JSON.stringify({
            "message-storage-policy": 0,
            "push-type": "LiveActivity"
        }));
    });
}

function publishToApns(channelId: any, json: any) {
    console.log(`channelId to push: ${channelId}, payload: ${JSON.stringify(json)}`);
    const session = http2.connect('https://api-broadcast.sandbox.push.apple.com:443');
    session.on('error', (err: any) => {
        console.log("Session Error", err);
    })
    
    try {
        const req = session.request(
            {
                ":method": "POST",
                ":path": "/4/broadcasts/apps/" + bundleID,
                "authorization": "bearer " + getAPNSAuthToken(),
                "apns-channel-id": channelId,
                "apns-push-type": "liveactivity",
                "apns-expiration": 0,
                "apns-priority": 10,
                "Content-Type": 'application/json'
            }
        );

        req.on('response', (headers: any) => {
            console.log(headers[http2.constants.HTTP2_HEADER_STATUS]);
        });

        let data = '';
        req.setEncoding('utf8');
        req.on('data', (chunk: any) => data += chunk);
        
        req.on('end', () => {
            console.log(`The server says: ${data}`);
            session.close();
        });
        req.end(JSON.stringify(json));
    } catch (err) {
        console.error("Error sending token:", err);
    }   
}

function deleteChannel(channelId: any): Promise<string> {
    return new Promise((resolve, reject) => {
        const session = http2.connect('https://api-manage-broadcast.sandbox.push.apple.com:2195');
        session.on('error', (err: any) => {
            console.log("Session Error", err);
            reject(err);
        })
        const req = session.request(
            {
                ":method": "DELETE",
                ":path": "/1/apps/" + bundleID + "/channels",
                "authorization": "bearer " + getAPNSAuthToken(),
                "apns-channel-id": channelId
            }
        );

        req.on('response', (headers: any) => {
            let status = headers[http2.constants.HTTP2_HEADER_STATUS] 
            console.log(status);
            if (status === 204) {
                resolve(headers['apns-channel-id']);
                return;
            }
            reject(status);
        });
        req.setEncoding('utf8');        
        req.on('end', () => {
            session.close();
        });
    });
}