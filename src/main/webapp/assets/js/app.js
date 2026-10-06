/**
 * BookStore — Main Application Script
 * Implements AJAX Add-to-Cart, Quantity Steppers, Catalogue Search/Filter,
 * Toast Notifications, and Enhanced Form Validations.
 */
(function () {
    'use strict';

    document.addEventListener('DOMContentLoaded', function () {
        initMiniCart();
        initToasts();
        initAjaxAddToCart();
        initQuantitySteppers();
        initCatalogueSearchAndFilter();
        initCartFeatures();
        initCheckoutHelpers();
    });

    /* ==========================================================================
       1. MINI CART & TOASTS
       ========================================================================== */

    function initMiniCart() {
        var miniCart = document.querySelector('.mini-cart');
        if (!miniCart) return;

        document.addEventListener('click', function (event) {
            if (miniCart.open && !miniCart.contains(event.target)) {
                miniCart.removeAttribute('open');
            }
        });
    }

    function initToasts() {
        var cartToast = document.getElementById('cartToast');
        if (cartToast) {
            setupToastElement(cartToast);
        }
    }

    function setupToastElement(el) {
        if (!el.querySelector('.cart-toast-close')) {
            var closeBtn = document.createElement('button');
            closeBtn.type = 'button';
            closeBtn.className = 'cart-toast-close';
            closeBtn.setAttribute('aria-label', 'Đóng thông báo');
            closeBtn.innerHTML = '&times;';
            closeBtn.addEventListener('click', function () {
                hideToast(el);
            });
            el.appendChild(closeBtn);
        }

        window.clearTimeout(el._dismissTimer);
        el._dismissTimer = window.setTimeout(function () {
            hideToast(el);
        }, 3600);
    }

    function hideToast(el) {
        if (!el) return;
        el.classList.add('cart-toast-hidden');
        window.setTimeout(function () {
            if (el.parentNode) el.parentNode.removeChild(el);
        }, 350);
    }

    function showToast(message, type) {
        type = type || 'success';
        var existing = document.getElementById('cartToast');
        if (existing) {
            existing.remove();
        }

        var toast = document.createElement('div');
        toast.id = 'cartToast';
        toast.className = 'cart-toast alert-' + type;
        toast.setAttribute('role', 'status');
        toast.setAttribute('aria-live', 'polite');

        var iconSvg = '<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>';
        if (type === 'danger') {
            iconSvg = '<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>';
        } else if (type === 'warning') {
            iconSvg = '<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>';
        }

        toast.innerHTML = iconSvg + ' <span>' + escapeHtml(message) + '</span>';
        document.body.appendChild(toast);
        setupToastElement(toast);
    }

    function escapeHtml(str) {
        return (str || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    /* ==========================================================================
       2. AJAX ADD TO CART (Item 3)
       ========================================================================== */

    function initAjaxAddToCart() {
        var cartForms = document.querySelectorAll('.home-cart-form, .add-cart-form, .detail-purchase-row');

        cartForms.forEach(function (form) {
            form.addEventListener('submit', function (event) {
                // If form is not inside a standard cart update/checkout
                var actionInput = form.querySelector('input[name="action"]');
                if (!actionInput || actionInput.value !== 'add') return;

                event.preventDefault();

                var submitBtn = form.querySelector('button[type="submit"]');
                var originalBtnHtml = submitBtn ? submitBtn.innerHTML : '';
                if (submitBtn) {
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<span class="btn-spinner"></span> Đang thêm...';
                }

                var formData = new FormData(form);
                var url = form.getAttribute('action');

                fetch(url, {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'Accept': 'application/json'
                    },
                    body: new URLSearchParams(formData)
                })
                .then(function (res) {
                    if (!res.ok) throw new Error('HTTP ' + res.status);
                    return res.json();
                })
                .then(function (data) {
                    if (data.success) {
                        updateCartCount(data.itemCount);
                        showToast(data.message || 'Đã thêm sách vào giỏ thành công!', data.type || 'success');

                        if (submitBtn) {
                            submitBtn.innerHTML = '✓ Đã thêm vào giỏ!';
                            window.setTimeout(function () {
                                submitBtn.disabled = false;
                                submitBtn.innerHTML = originalBtnHtml;
                            }, 1600);
                        }
                    } else {
                        showToast(data.message || 'Không thể thêm sách vào giỏ.', data.type || 'danger');
                        if (submitBtn) {
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = originalBtnHtml;
                        }
                    }
                })
                .catch(function () {
                    // Fallback to normal form submit if fetch fails
                    form.submit();
                });
            });
        });
    }

    function updateCartCount(count) {
        var cartSummary = document.querySelector('.cart-icon-btn');
        if (!cartSummary) return;

        var counter = cartSummary.querySelector('.cart-counter');
        if (!counter && count > 0) {
            counter = document.createElement('span');
            counter.className = 'cart-counter';
            cartSummary.appendChild(counter);
        }

        if (counter) {
            if (count > 0) {
                counter.textContent = count;
                counter.style.display = 'inline-block';
                counter.classList.remove('cart-bump');
                // Trigger reflow for re-animation
                void counter.offsetWidth;
                counter.classList.add('cart-bump');
            } else {
                counter.style.display = 'none';
            }
        }
    }

    /* ==========================================================================
       3. TACTILE QUANTITY STEPPER (Items 5 & 6)
       ========================================================================== */

    function initQuantitySteppers() {
        var steppers = document.querySelectorAll('.quantity-stepper-control');

        steppers.forEach(function (stepper) {
            var input = stepper.querySelector('.stepper-input');
            var minusBtn = stepper.querySelector('.stepper-minus');
            var plusBtn = stepper.querySelector('.stepper-plus');
            if (!input || !minusBtn || !plusBtn) return;

            function updateButtonsState() {
                var val = parseInt(input.value, 10) || 1;
                var min = parseInt(input.min, 10) || 1;
                var max = parseInt(input.max, 10) || 9999;
                minusBtn.disabled = val <= min;
                plusBtn.disabled = val >= max;
            }

            minusBtn.addEventListener('click', function () {
                var current = parseInt(input.value, 10) || 1;
                var min = parseInt(input.min, 10) || 1;
                if (current > min) {
                    input.value = current - 1;
                    input.dispatchEvent(new Event('change', { bubbles: true }));
                }
                updateButtonsState();
            });

            plusBtn.addEventListener('click', function () {
                var current = parseInt(input.value, 10) || 1;
                var max = parseInt(input.max, 10) || 9999;
                if (current < max) {
                    input.value = current + 1;
                    input.dispatchEvent(new Event('change', { bubbles: true }));
                }
                updateButtonsState();
            });

            input.addEventListener('change', updateButtonsState);
            updateButtonsState();
        });
    }

    /* ==========================================================================
       4. CATALOGUE FILTER & SEARCH ENGINE (Item 4 - products.jsp)
       ========================================================================== */

    function initCatalogueSearchAndFilter() {
        var toolbar = document.querySelector('.catalogue-toolbar');
        if (!toolbar) return;

        var searchInput = document.getElementById('catalogueSearchInput');
        var clearBtn = document.getElementById('catalogueSearchClear');
        var stockFilter = document.getElementById('catalogueStockFilter');
        var priceFilter = document.getElementById('cataloguePriceFilter');
        var sortFilter = document.getElementById('catalogueSortFilter');
        var resultCountLabel = document.getElementById('catalogueResultCount');
        var emptyState = document.getElementById('catalogueEmptyState');
        var resetBtn = document.getElementById('catalogueResetBtn');

        var bookGrid = document.querySelector('.book-shelf-grid');
        if (!bookGrid) return;

        var bookCards = Array.from(bookGrid.querySelectorAll('.book-card-item'));
        var totalBooks = bookCards.length;

        function applyFilters() {
            var query = (searchInput ? searchInput.value : '').trim().toLowerCase();
            var stockVal = stockFilter ? stockFilter.value : 'all';
            var priceVal = priceFilter ? priceFilter.value : 'all';
            var sortVal = sortFilter ? sortFilter.value : 'default';

            if (clearBtn) {
                clearBtn.style.display = query.length > 0 ? 'block' : 'none';
            }

            var visibleCards = [];

            bookCards.forEach(function (card) {
                var title = (card.getAttribute('data-title') || '').toLowerCase();
                var author = (card.getAttribute('data-author') || '').toLowerCase();
                var publisher = (card.getAttribute('data-publisher') || '').toLowerCase();
                var stock = parseInt(card.getAttribute('data-stock'), 10) || 0;
                var price = parseFloat(card.getAttribute('data-price')) || 0;

                // 1. Text Search matching
                var matchesSearch = !query ||
                    title.indexOf(query) !== -1 ||
                    author.indexOf(query) !== -1 ||
                    publisher.indexOf(query) !== -1;

                // 2. Stock matching
                var matchesStock = true;
                if (stockVal === 'in-stock') matchesStock = stock > 0;
                else if (stockVal === 'out-of-stock') matchesStock = stock <= 0;

                // 3. Price matching
                var matchesPrice = true;
                if (priceVal === 'under-30') matchesPrice = price < 30;
                else if (priceVal === '30-50') matchesPrice = price >= 30 && price <= 50;
                else if (priceVal === 'over-50') matchesPrice = price > 50;

                if (matchesSearch && matchesStock && matchesPrice) {
                    card.style.display = '';
                    visibleCards.push(card);
                } else {
                    card.style.display = 'none';
                }
            });

            // 4. Sorting
            if (sortVal !== 'default' && visibleCards.length > 1) {
                visibleCards.sort(function (a, b) {
                    var priceA = parseFloat(a.getAttribute('data-price')) || 0;
                    var priceB = parseFloat(b.getAttribute('data-price')) || 0;
                    var titleA = (a.getAttribute('data-title') || '').toLowerCase();
                    var titleB = (b.getAttribute('data-title') || '').toLowerCase();

                    if (sortVal === 'price-asc') return priceA - priceB;
                    if (sortVal === 'price-desc') return priceB - priceA;
                    if (sortVal === 'title-asc') return titleA.localeCompare(titleB);
                    return 0;
                });

                visibleCards.forEach(function (card) {
                    bookGrid.appendChild(card);
                });
            }

            // 5. Update Status
            if (resultCountLabel) {
                resultCountLabel.textContent = 'Hiển thị ' + visibleCards.length + ' / ' + totalBooks + ' ấn bản';
            }

            if (emptyState) {
                emptyState.style.display = visibleCards.length === 0 ? 'block' : 'none';
            }
        }

        if (searchInput) {
            searchInput.addEventListener('input', applyFilters);
        }
        if (clearBtn) {
            clearBtn.addEventListener('click', function () {
                searchInput.value = '';
                searchInput.focus();
                applyFilters();
            });
        }
        if (stockFilter) stockFilter.addEventListener('change', applyFilters);
        if (priceFilter) priceFilter.addEventListener('change', applyFilters);
        if (sortFilter) sortFilter.addEventListener('change', applyFilters);

        if (resetBtn) {
            resetBtn.addEventListener('click', function () {
                if (searchInput) searchInput.value = '';
                if (stockFilter) stockFilter.value = 'all';
                if (priceFilter) priceFilter.value = 'all';
                if (sortFilter) sortFilter.value = 'default';
                applyFilters();
            });
        }
    }

    /* ==========================================================================
       5. CART ENHANCEMENTS (Item 6 - cart.jsp)
       ========================================================================== */

    function initCartFeatures() {
        var cartTable = document.querySelector('.cart-editorial-table');
        if (!cartTable) return;

        // Removal Confirmation
        var removeForms = document.querySelectorAll('.cart-remove-form');
        var modal = document.getElementById('cartConfirmModal');
        var confirmYesBtn = document.getElementById('cartConfirmYes');
        var confirmNoBtn = document.getElementById('cartConfirmNo');
        var pendingForm = null;

        if (modal && confirmYesBtn && confirmNoBtn) {
            removeForms.forEach(function (form) {
                form.addEventListener('submit', function (e) {
                    e.preventDefault();
                    pendingForm = form;
                    modal.classList.add('is-active');
                });
            });

            confirmYesBtn.addEventListener('click', function () {
                if (pendingForm) {
                    modal.classList.remove('is-active');
                    pendingForm.submit();
                }
            });

            confirmNoBtn.addEventListener('click', function () {
                modal.classList.remove('is-active');
                pendingForm = null;
            });

            modal.addEventListener('click', function (e) {
                if (e.target === modal) {
                    modal.classList.remove('is-active');
                    pendingForm = null;
                }
            });
        }
    }

    /* ==========================================================================
       6. CHECKOUT FORM HELPERS (Item 6 - checkout.jsp)
       ========================================================================== */

    function initCheckoutHelpers() {
        var phoneInput = document.getElementById('recipientPhone');
        var addressInput = document.getElementById('shippingAddress');
        var addressCharCount = document.getElementById('addressCharCount');

        if (phoneInput) {
            phoneInput.addEventListener('input', function () {
                // Strip invalid characters, allow digits, spaces, dots, dashes
                this.value = this.value.replace(/[^\d\s\-\.\+]/g, '');
            });
        }

        if (addressInput && addressCharCount) {
            var updateCharCount = function () {
                var len = addressInput.value.trim().length;
                addressCharCount.textContent = len + ' ký tự (tối thiểu 10 ký tự)';
                if (len < 10) {
                    addressCharCount.style.color = 'var(--state-danger-text)';
                } else {
                    addressCharCount.style.color = 'var(--state-success-text)';
                }
            };
            addressInput.addEventListener('input', updateCharCount);
            updateCharCount();
        }
    }

})();
