<!DOCTYPE HTML>
<html>
<head>
<#include "./Head.ftl">
    <meta name="google-site-verification" content="x0X03pS11CEzsxQpTwmMrsEDoZM29YFZVLazajNxSxU"/>
</head>
<body>

<#include "./Nav.ftl">

<div class="container">
    <h3 class="page-header">PGPM.io</h3>

    <p class="lead">
        Create a URL to distribute to your friends as a method of sending you messages encrypted with your PGP key.
    </p>
    <ol>
        <li>Create an entry by completing this form</li>
        <li>Send the link you receive via e-mail to your friends</li>
        <li>Receive encrypted messages created via your link</li>
        <li>Decrypt with your PGP key</li>
    </ol>

    <hr/>

    <form id="createLinkForm" method="POST" action="/">
        <div class="form-group">
            <label for="email">E-mail</label>
            <input type="email" class="form-control" id="email" name="email" placeholder="E-mail Address" required>
        </div>

        <div class="form-group">
            <label class="control-label" for="key">Public Key</label>
            <textarea class="form-control" id="key" name="publicKey" placeholder="Paste in your Public Key"
                      required></textarea>
        </div>

        <div class="checkbox">
            <label>
                <input type="checkbox" name="mailtoLink" checked="checked"> Use 'mailto' link
            </label>
            <p class="help-block">
                This forces the message sender to use their own e-mail client to send the e-mail. You can expect
                to receive encrypted messages directly from the user. However this exposes your e-mail address.
            </p>
        </div>

        <div class="form-group" style="display:none;">
            <label class="control-label" for="privateKey">Generated Private Key <strong>(Keep This)</strong></label>
            <textarea class="form-control" id="privateKey" placeholder="Private Key" readOnly></textarea>
        </div>

        <div class="form-group">
            <button type="button" id="generateKeyBtn" class="btn btn-default btn-block">
                <i id="generateKeyIcon" class="fa fa-plus"></i>
                Generate Key Pair
            </button>
        </div>

        <div class="form-group">
            <button type="submit" id="submitBtn" class="btn btn-primary btn-block">
                <i id="submitIcon" class="fa fa-chain"></i>
                Create Link
            </button>
        </div>

        <script>
            // whether the form is currently submitting
            var key = $("#key");
            var pk = $("#privateKey");
            var genKey = $("#generateKeyBtn");
            var genIcon = $("#generateKeyIcon");
            var submitBtn = $("#submitBtn");
            var submitIcon = $("#submitIcon");
            var fm = $("#createLinkForm");
            var spinnerClass = "fa-spinner fa-pulse";

            var generateKey = function generateKey() {
                submitBtn.prop("disabled", true);
                genKey.prop("disabled", true);
                genIcon.removeClass("fa-plus").addClass(spinnerClass);
                setTimeout(function () {
                    openpgp.generateKeyPair({
                        numBits: 4096,
                        userId: "PGPM",
                        unlocked: true
                    }).then(function (keypair) {
                        submitBtn.prop("disabled", false);
                        genKey.prop("disabled", false);
                        genIcon.removeClass(spinnerClass).addClass("fa-plus");
                        // insert values into key fields
                        var privKey = keypair.privateKeyArmored;
                        var pubkey = keypair.publicKeyArmored;
                        key.val(pubkey);
                        pk.val(privKey).closest(".form-group").css("display", "");
                    }, function (error) {
                        submitBtn.prop("disabled", false);
                        genKey.prop("disabled", false);
                        genIcon.removeClass(spinnerClass).addClass("fa-plus");
                        // error occurred, remove values from key fields
                        pk.val("").closest(".form-group").css("display", "none");
                        key.val("");
                        alert(error);
                    });
                }, 50);
            };
            genKey.on("click", generateKey);

            var verifyKey = function verifyKey(key) {
                var publicKey = openpgp.key.readArmored(key);
                return publicKey.keys.length === 1;
            };

            var submitForm = function submitForm(e) {
                if (verifyKey(key.val())) {
                    genKey.prop("disabled", true);
                    submitBtn.prop("disabled", true);
                    submitIcon.removeClass("fa-link").addClass(spinnerClass);
                } else {
                    // prevent form submission
                    e.preventDefault();
                    alert("Invalid key.");
                }
            };
            fm.on("submit", submitForm);

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
<#include "./GoogleAnalytics.ftl">
</div>
</body>
</html>