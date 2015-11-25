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

    <form method="POST" onsubmit="disableSubmit();">
        <div class="form-group">
            <label for="email">E-mail</label>
            <input type="email" class="form-control" id="email" name="email" placeholder="E-mail Address" required>
        </div>
        <div class="form-group">
            <label class="control-label" for="key">Public Key</label>
            <textarea class="form-control" id="key" name="publicKey" placeholder="Public Key" required></textarea>
        </div>

        <div class="form-group">
            <button type="submit" id="submitBtn" class="btn btn-primary btn-block"><i class="fa fa-chain"></i> Create
                Link
            </button>
        </div>
        <script>
            function disableSubmit() {
                document.getElementById("submitBtn").disabled = true;
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

</body>
</html>