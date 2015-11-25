<!DOCTYPE HTML>
<html>
<head>
<#include "./Head.ftl">
</head>
<body>

<#include "./Nav.ftl">

<div class="container">
    <h3 class="page-header">PGPMessager</h3>

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

</div>

</body>
</html>