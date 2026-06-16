
const { onRequest } = require("firebase-functions/v2/https");
const { google } = require("googleapis");

const PACKAGE_NAME = "com.yourcompany.yourgame"; // change this

function normalizeNonce(value) {
    if (!value) {
        return "";
    }

    return String(value)
        .replace(/\+/g, "-")
        .replace(/\//g, "_")
        .replace(/=/g, "")
        .replace(/\r/g, "")
        .replace(/\n/g, "")
        .trim();
}

exports.verifyPlayIntegrity = onRequest(async (req, res) => {
    try {
        if (req.method !== "POST") {
            return res.status(405).json({
                success: false,
                error: "POST required"
            });
        }

        const token = req.body && req.body.token ? req.body.token : "";
        const expectedNonce = req.body && req.body.nonce ? req.body.nonce : "";

        if (!token || !expectedNonce) {
            return res.status(400).json({
                success: false,
                error: "Missing token or nonce"
            });
        }

        const auth = new google.auth.GoogleAuth({
            scopes: ["https://www.googleapis.com/auth/playintegrity"]
        });

        const playintegrity = google.playintegrity({
            version: "v1",
            auth: auth
        });

        const result = await playintegrity.v1.decodeIntegrityToken({
            packageName: PACKAGE_NAME,
            requestBody: {
                integrityToken: token
            }
        });

        const verdict = result.data.tokenPayloadExternal;

        let requestNonce = "";
        let appRecognitionVerdict = "";
        let appLicensingVerdict = "";
        let deviceIntegrity = [];

        if (verdict && verdict.requestDetails && verdict.requestDetails.nonce) {
            requestNonce = verdict.requestDetails.nonce;
        }

        if (verdict && verdict.appIntegrity && verdict.appIntegrity.appRecognitionVerdict) {
            appRecognitionVerdict = verdict.appIntegrity.appRecognitionVerdict;
        }

        if (verdict && verdict.accountDetails && verdict.accountDetails.appLicensingVerdict) {
            appLicensingVerdict = verdict.accountDetails.appLicensingVerdict;
        }

        if (verdict && verdict.deviceIntegrity && verdict.deviceIntegrity.deviceRecognitionVerdict) {
            deviceIntegrity = verdict.deviceIntegrity.deviceRecognitionVerdict;
        }

        const normalizedExpectedNonce = normalizeNonce(expectedNonce);
        const normalizedRequestNonce = normalizeNonce(requestNonce);

        const nonceOk = normalizedRequestNonce === normalizedExpectedNonce;
        const appOk = appRecognitionVerdict === "PLAY_RECOGNIZED";
        const licenseOk = appLicensingVerdict === "LICENSED";

        // Strict production rule:
        const passed = nonceOk && appOk && licenseOk;

        // Useful while testing local APKs:
        const localTestPassed = nonceOk;

        return res.status(200).json({
            success: true,
            passed: passed,
            localTestPassed: localTestPassed,
            checks: {
                nonceOk: nonceOk,
                appOk: appOk,
                licenseOk: licenseOk
            },
            verdicts: {
                expectedNonce: expectedNonce,
                requestNonce: requestNonce,
                normalizedExpectedNonce: normalizedExpectedNonce,
                normalizedRequestNonce: normalizedRequestNonce,
                appRecognitionVerdict: appRecognitionVerdict,
                appLicensingVerdict: appLicensingVerdict,
                deviceIntegrity: deviceIntegrity
            },
            raw: verdict
        });
    }
    catch (e) {
        console.error("verifyPlayIntegrity failed:", e);

        return res.status(500).json({
            success: false,
            error: e.message || String(e)
        });
    }
});
