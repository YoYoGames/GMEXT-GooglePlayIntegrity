
package ${YYAndroidPackageName};

import ${YYAndroidPackageName}.GMExtWire.GMFunction;
import ${YYAndroidPackageName}.GMExtUtils;

import androidx.annotation.NonNull;

import com.google.android.play.core.integrity.IntegrityManager;
import com.google.android.play.core.integrity.IntegrityManagerFactory;
import com.google.android.play.core.integrity.IntegrityTokenRequest;
import com.google.android.play.core.integrity.IntegrityTokenResponse;

public class GMPlayIntegrity extends GMPlayIntegrityInternal {

    private static final String EXTENSION_NAME = "GMPlayIntegrity";
    private static final String OPTION_CLOUD_PROJECT_NUMBER = "CLOUD_PROJECT_NUMBER";

    private IntegrityManager mIntegrityManager = null;

    private IntegrityManager play_integrity_get_manager() {
        if (mIntegrityManager == null) {
            if (RunnerActivity.CurrentActivity == null) {
                return null;
            }

            mIntegrityManager = IntegrityManagerFactory.create(RunnerActivity.CurrentActivity);
        }

        return mIntegrityManager;
    }

    private long play_integrity_get_cloud_project_number() throws Exception {
        String value = GMExtUtils.GetExtensionOption(EXTENSION_NAME, OPTION_CLOUD_PROJECT_NUMBER);

        if (value == null || value.trim().isEmpty()) {
            throw new Exception("Missing extension option: " + OPTION_CLOUD_PROJECT_NUMBER);
        }

        return Long.parseLong(value.trim());
    }

    public boolean play_integrity_request_token(String nonce, GMFunction callback) {
        if (callback == null) {
            return false;
        }

        if (nonce == null || nonce.trim().isEmpty()) {
            callback.call(false, "", "Nonce is empty.");
            return false;
        }

        try {
            IntegrityManager integrityManager = play_integrity_get_manager();

            if (integrityManager == null) {
                callback.call(false, "", "Current Android activity is unavailable.");
                return false;
            }

            long cloudProjectNumber = play_integrity_get_cloud_project_number();

            IntegrityTokenRequest request = IntegrityTokenRequest.builder()
                    .setCloudProjectNumber(cloudProjectNumber)
                    .setNonce(nonce)
                    .build();

            integrityManager.requestIntegrityToken(request)
                    .addOnSuccessListener(new com.google.android.gms.tasks.OnSuccessListener<IntegrityTokenResponse>() {
                        @Override
                        public void onSuccess(IntegrityTokenResponse integrityTokenResponse) {
                            String token = integrityTokenResponse.token();

                            if (token == null) {
                                token = "";
                            }

                            callback.call(true, token, "");
                        }
                    })
                    .addOnFailureListener(new com.google.android.gms.tasks.OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            String error = e.getMessage();

                            if (error == null || error.isEmpty()) {
                                error = e.toString();
                            }

                            callback.call(false, "", error);
                        }
                    });

            return true;
        }
        catch (Exception e) {
            String error = e.getMessage();

            if (error == null || error.isEmpty()) {
                error = e.toString();
            }

            callback.call(false, "", error);
            return false;
        }
    }
}