 document.addEventListener("DOMContentLoaded", function () {

    var  footer = document.getElementById('pie');
    var card1 = document.getElementById('card1');
    var card2 = document.getElementById('card2');
    var forgotPasswordBtn = document.getElementById("forgot-password");

    // Agregar un evento de clic al botón
    forgotPasswordBtn.addEventListener("click", function() {
        // Redirigir a la página rem_pass.pl
        window.location.href = "forgotten_pass.html";
    });









    // Función para mostrar el contenido según la sección seleccionada
    window.mostrarContenido = function (seccion) {
        // Ocultar todos los contenidos
        var contenidos = document.getElementsByClassName('container');
        var botones = document.getElementsByClassName('content');
        var card1 = document.getElementById('card1');
        var card2 = document.getElementById('card2');
        var card3 = document.getElementById('card3');



        for (var i = 0; i < botones.length; i++) {
            botones[i].classList.remove('active');
        }
        
        // Agregar la clase 'active' solo al botón que ha sido clicado
        document.getElementById('btn' + seccion.charAt(0).toUpperCase() + seccion.slice(1)).classList.add('active');

        for (var i = 0; i < contenidos.length; i++) {
            contenidos[i].style.display = 'none';
        }

        // Mostrar el contenido de la sección seleccionada
        var contenido = document.getElementById('contenido-' + seccion);
        contenido.style.display = 'block';

        // Detener la galería si no estamos en la sección de inicio
        if (seccion == 'start') {
            footer.style.display = 'none';
        }
        if(seccion == 'productos'){
	    footer.style.display = 'block';
            card1.style.display = 'block';
            card2.style.display = 'block';
            card3.style.display = 'block';

        } else {
            footer.style.display = 'block';
            card1.style.display = 'none';
            card2.style.display = 'none';
            card3.style.display = 'none';

        }
    };


})

 
let slideIndex = 0;
showSlides();



function showSlides() {
  let i;
  let slides = document.getElementsByClassName("mySlides");
  for (i = 0; i < slides.length; i++) {
    slides[i].style.display = "none";
  }
  slideIndex++;
  if (slideIndex > slides.length) {slideIndex = 1}
  slides[slideIndex-1].style.display = "block";
  setTimeout(showSlides, 5000); // Change image every 2 seconds
}


 
        function mostrarMensaje() {
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');

            if (success === 'true') {
                // El registro fue exitoso
                alert('Registro exitoso');
            } else if (success === 'false') {
                // El registro no fue exitoso
                alert('Error al registrar usuario');
            }
        }


$( '.navbar-nav a' ).on( 'click', function () {
	$( '.navbar-nav' ).find( 'li.active' ).removeClass( 'active' );
	$( this ).parent( 'li' ).addClass( 'active' );
});
