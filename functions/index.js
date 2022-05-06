const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.timedLeaderboardCleanup = functions.firestore
  .document("leaderboard/{leaderboardEntry}")
  .onCreate(async (_, __) => {
    functions.logger.info(
      "Document created, getting all leaderboard documents"
    );
    const snapshot = await db
      .collection("leaderboard")
      .orderBy("score", "desc")
      .offset(10)
      .get();

    functions.logger.info(
      `Preparing to delete ${snapshot.docs.length} documents.`
    );
    try {
      await Promise.all(snapshot.docs.map((doc) => doc.ref.delete()));
      functions.logger.info("Success");
    } catch (error) {
      functions.logger.error(`Failed to delete documents ${error}`);
    }
  });
