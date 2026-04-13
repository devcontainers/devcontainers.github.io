(function () {
    const searchInput = document.getElementById('searchInput');
    const collectionTable = document.getElementById('collectionTable');

    if (!searchInput || !collectionTable) {
        return;
    }

    const rows = collectionTable.getElementsByTagName('tr');

    function performSearch() {
        const searchValue = searchInput.value.toLowerCase();

        for (let i = 1; i < rows.length; i++) {
            const name = rows[i].getElementsByTagName('td')[0].textContent.toLowerCase();
            const maintainer = rows[i].getElementsByTagName('td')[1].textContent.toLowerCase();
            const repository = rows[i].getElementsByTagName('td')[2] ? rows[i].getElementsByTagName('td')[2].textContent.toLowerCase() : '';

            if (name.includes(searchValue) || maintainer.includes(searchValue) || repository.includes(searchValue)) {
                rows[i].style.display = '';
            } else {
                rows[i].style.display = 'none';
            }
        }
    }

    function updateURL() {
        const url = new URL(window.location);
        if (searchInput.value) {
            url.searchParams.set('search', searchInput.value);
        } else {
            url.searchParams.delete('search');
        }
        window.history.replaceState({}, '', url);
    }

    function loadSearchFromURL() {
        const urlParams = new URLSearchParams(window.location.search);
        const searchParam = urlParams.get('search');
        if (searchParam) {
            searchInput.value = searchParam;
            performSearch();
        }
    }

    searchInput.addEventListener('input', function () {
        performSearch();
        updateURL();
    });

    // Initialize search from URL on page load
    loadSearchFromURL();
})();
