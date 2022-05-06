const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

exports.timedLeaderboardCleanup = functions.firestore
    .document('leaderboard/{leaderboardEntry}')
    .onCreate((snap, context) => {
        functions.logger.info('Document created, getting all leaderboard documents')
        var allLeaderBoardEntries = db.collection('leaderboard').orderBy('score','desc').get().then(function(snapshot) {
            functions.logger.info('Leaderboard contains ' + snapshot.docs.length + ' entries');
            if(snapshot.docs.length > 10) {
                for(var i = 10; i < snapshot.docs.length; i++) {
                    functions.logger.info('Deleting entry number ' + (i + 1) + ' in the leaderboard');
                    snapshot.docs[i].ref.delete()
                        .then(function() {
                            functions.logger.info('Delete successful');
                            return true;
                        })
                        .catch(function(error) {
                            functions.logger.error('Error in Deleting record');
                            return false;
                        });
                }
            }
            else {
                functions.logger.info('Leaderboard is less then 10 entries. No action taken.');
                return true;
            }
        });
    });