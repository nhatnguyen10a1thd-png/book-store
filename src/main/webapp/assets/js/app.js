/**
 * BookStore — Main Application Script
 * Handles mini-cart interactions and toast notifications.
 */
(function () {
    'use strict';

    document.addEventListener('DOMContentLoaded', function () {
        var miniCart = document.querySelector('.mini-cart');
        var cartToast = document.getElementById('cartToast');

        /* Close mini-cart when clicking outside */
        if (miniCart) {
            document.addEventListener('click', function (event) {
                if (miniCart.open && !miniCart.contains(event.target)) {
                    miniCart.removeAttribute('open');
                }
            });
        }

        /* Auto-dismiss cart toast after 3.2 s */
        if (cartToast) {
            window.setTimeout(function () {
                cartToast.classList.add('cart-toast-hidden');
            }, 3200);
        }
    });
})();
