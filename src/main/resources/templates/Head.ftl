<title>PGPM.io</title>
<meta name="author" content="Moody Salem"/>
<meta name="description" content="Generate links for friends to send you PGP encrypted messages"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

<!--bootstrap-->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.6/css/bootstrap.min.css"
      integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<!--fontawesome-->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css"
      integrity="sha384-XdYbMnZ/QjLh6iI4ogqCTaIjrFk87ip+ekIjefZch0Y+PvJ8CDYtEs1ipDmPorQ+" crossorigin="anonymous">
<!--openpgp-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/openpgp/1.3.0/openpgp.min.js"
        integrity="sha384-axns8EaVPUSN6JCoGPirqvkhZrK/SEjoFLmufTFb1VSZtQ5K/tFvJ4Fc5+gBiEPl"
        crossorigin="anonymous"></script>
<!--jquery-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"
        integrity="sha384-6ePHh72Rl3hKio4HiJ841psfsRJveeS+aLoaEf3BWfS+gTF0XdAqku2ka8VddikM"
        crossorigin="anonymous"></script>

<style>
    .navbar-brand .logo-color {
        color: red;
    }

    textarea {
        resize: vertical;
        height: 150px !important;
    }

    .page-footer {
        margin-bottom: 1em;
        opacity: 0.6
    }
</style>

<script>
    // unfortunately only JS redirection is supported
    if (window.location.protocol != "https:") {
        window.location.href = "https:" + window.location.href.substring(window.location.protocol.length);
    }
</script>