<!DOCTYPE HTML>
<html>
<head>
<#include "./Head.ftl">
</head>
<body>

<#include "./Nav.ftl">

<div class="container">
    <h3 class="page-header">PGPMessager</h3>

    <p class="lead">
        This is a simple utility for creating a page for your non-technical friends to send you messages that are
        encryped with your PGP public key.
        You use this form to generate a link, send the link to your friends, and have them message you via the form in
        the link.
        All messages are encrypted in the browser via openPGP before being transmitted over the wire, and are thus not
        exposed
        to MITM attacks.
    </p>

    <hr/>

    <form id="createLinkForm" method="POST" action="/">
        <div class="form-group">
            <label for="email">E-mail</label>
            <input type="email" class="form-control" id="email" name="email" placeholder="E-mail Address" required>
        </div>

        <div class="form-group">
            <label class="control-label" for="key">Public Key</label>
            <textarea class="form-control" id="key" name="publicKey" placeholder="Public Key" required></textarea>
        </div>

        <div class="form-group">
            <button type="button" id="generate-key" class="btn btn-default btn-block" onclick="generateKey();"><i
                    id="plus-icon"
                    class="fa fa-plus"></i>
                Generate Key Pair
            </button>
        </div>

        <div class="form-group">
            <button type="button" id="submitBtn" class="btn btn-primary btn-block" onclick="submitForm();"><i
                    id="chain-icon"
                    class="fa fa-chain"></i>
                Create Link
            </button>
        </div>
        <script>

            var submitting = false;

            function enableSubmit() {
                if (submitting) {
                    return;
                }
                $("#submitBtn").prop("disabled", false);
                $("#chain-icon").removeClass("fa-spinner fa-pulse").addClass("fa-chain");
            }

            function disableSubmit() {
                $("#submitBtn").prop("disabled", true);
                $("#chain-icon").removeClass("fa-chain").addClass("fa-spinner fa-pulse");
            }


            function enableGenerate() {
                if (submitting) {
                    return;
                }
                $("#generate-key").prop("disabled", false);
                $("#plus-icon").addClass("fa-plus").removeClass("fa-spinner fa-pulse");
            }

            function disableGenerate() {
                $("#generate-key").prop("disabled", true);
                $("#plus-icon").removeClass("fa-plus").addClass("fa-spinner fa-pulse");
            }

            function generateKey() {
                disableSubmit();
                disableGenerate();
                openpgp.generateKeyPair({
                    numBits: 4096,
                    userId: "PGPMessager Generated",
                    unlocked: true
                }).then(function (keypair) {
                    enableSubmit();
                    enableGenerate();
                    var pk = keypair.privateKeyArmored;
                    var pubkey = keypair.publicKeyArmored;
                    $("#key").val(pubkey);
                    window.prompt("Here is your private key. Copy to clipboard: Ctrl+C, Enter", pubkey + "\n" + pk);
                }, function (error) {
                    enableSubmit();
                    enableGenerate();
                    alert(error);
                });
            }

            function verifyKey(key) {
                return true;
            }

            function submitForm() {
                if (verifyKey($("#key").val())) {
                    submitting = true;
                    disableGenerate();
                    disableSubmit();
                    $("#createLinkForm").submit();
                } else {
                    alert("Invalid key.");
                }
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
</div>

<#include "./GoogleAnalytics.ftl">
</body>
</html>