<!DOCTYPE HTML>
<html>
<head>
<#include "./Head.ftl">
</head>
<body>

<#include "./Nav.ftl">


<div class="container">
    <h3 class="page-header">About</h3>

    <p class="lead">
        Use this form to contact whomever sent you this link.
    </p>

    <hr/>

    <form method="POST" onsubmit="disableSubmit();">
        <div class="form-group">
            <label for="message">Your unencrypted message</label>
            <textarea class="form-control" id="message" placeholder="Your unencrypted message"
                      required></textarea>
        </div>
        <div class="form-group">
            <label class="control-label" for="key">Your friend's public key</label>
            <textarea readOnly class="form-control" id="key" name="publicKey"
                      placeholder="Public Key">${model.entry.publicKey?html}</textarea>
        </div>

        <div class="form-group">
            <button type="button" id="encryptButton" class="btn btn-primary btn-block" onclick="encryptMessage();"><i
                    id="lock-icon"
                    class="fa fa-lock"></i>
                Encrypt Message
            </button>
        </div>

        <div class="form-group">
            <label class="control-label" for="encryptedMessage">Your encrypted message</label>
                        <textarea readOnly class="form-control" id="encryptedMessage" name="message"
                                  placeholder="Your encrypted message"
                                  required></textarea>
        </div>

        <div class="form-group">
            <button type="submit" id="submitBtn" class="btn btn-success btn-block" disabled><i id="envelope-icon"
                                                                                               class="fa fa-envelope"></i>
                Send
            </button>
        </div>
        <script>
            function enableSubmit() {
                $("#submitBtn").prop("disabled", false);
                $("#envelope-icon").removeClass("fa-spinner fa-pulse").addClass("fa-envelope");
            }

            function disableSubmit() {
                $("#submitBtn").prop("disabled", true);
                $("#envelope-icon").addClass("fa-spinner fa-pulse").removeClass("fa-envelope");
            }

            function enableEncrypt() {
                $("#encryptButton").prop("disabled", false);
                $("#lock-icon").removeClass("fa-spinner fa-pulse").addClass("fa-lock");
            }

            function disableEncrypt() {
                $("#encryptButton").prop("disabled", true);
                $("#lock-icon").addClass("fa-spinner fa-pulse").removeClass("fa-lock");
            }

            function undoEncrypt() {
                $("#encryptedMessage").val("");
                $("#submitBtn").prop("disabled", true);
            }

            var textArea = $("#message");
            textArea.on("input propertychange", undoEncrypt);

            function encryptMessage() {
                var key = $("#key").val();
                var publicKey = openpgp.key.readArmored(key);
                disableEncrypt();
                openpgp.encryptMessage(publicKey.keys, $("#message").val()).then(function (pgpMessage) {
                    // success
                    $("#encryptedMessage").val(pgpMessage);
                    enableSubmit();
                    enableEncrypt();
                }).catch(function (error) {
                    alert(error);
                    enableEncrypt();
                    // we don't use disablesubmit because that shows a loading icon
                    $("#submitBtn").prop("disabled", true);
                });
            }
        </script>
    </form>

<#if (model.errorMessage)??>
    <div class="alert alert-danger">
        <i class="fa fa-exclamation-triangle"></i> ${model.errorMessage?html}
    </div>
</#if>

<#if (model.successMessage)??>
    <div class="alert alert-success">
        <i class="fa fa-check"></i> ${model.successMessage?html}
    </div>
</#if>

<#include "./Footer.ftl">
</div>

<#include "./GoogleAnalytics.ftl">
</body>
</html>