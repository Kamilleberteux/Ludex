let currentMarkers = [];
let allPlaces = [];
let allMarkersData = [];
let suppressNextIdle = false;

function clearMarkers() {
  currentMarkers.forEach(marker => marker.setMap(null));
  currentMarkers = [];
  allPlaces = [];
  allMarkersData = [];
}

function filterResultsByBounds(map) {
  const bounds = map.getBounds();
  if (!bounds) return;
  const visible = allMarkersData.filter(({ marker }) =>
    bounds.contains(marker.getPosition())
  );
  renderResults(visible.map(d => d.place));
}

function expandCard(placeId) {
  const container = document.getElementById("map-results");
  container.querySelectorAll(".map-results__item--expanded").forEach(el => {
    if (el.dataset.placeId !== placeId) el.classList.remove("map-results__item--expanded");
  });
  const item = container.querySelector(`[data-place-id="${placeId}"]`);
  if (item) item.classList.toggle("map-results__item--expanded");
}

function renderResults(results) {
  const container = document.getElementById("map-results");
  container.innerHTML = "";

  if (!results || results.length === 0) {
    container.innerHTML = `<p class="map-results__empty">Aucun bar à jeu trouvé dans cette zone.</p>`;
    return;
  }

  results.forEach((place, index) => {
    const rating = place.rating ? `<span class="map-results__rating">★ ${place.rating}</span>` : "";
    const reviewCount = place.user_ratings_total ? `<span class="map-results__reviews">(${place.user_ratings_total})</span>` : "";
    const status = place.opening_hours
      ? `<span class="map-results__status map-results__status--${place.opening_hours.open_now ? "open" : "closed"}">${place.opening_hours.open_now ? "Ouvert" : "Fermé"}</span>`
      : "";
    const photos = (place.photos || []).slice(0, 2);
    const photoCount = photos.length;
    const photoHtml = photos.map(p =>
      `<img class="map-results__photo map-results__photo--${photoCount}" src="${p.getUrl({ maxWidth: 600 })}" alt="${place.name}" />`
    ).join("");
    const photo = photoHtml ? `<div class="map-results__photos">${photoHtml}</div>` : "";

    const item = document.createElement("div");
    item.className = "map-results__item";
    item.dataset.index = index;
    item.dataset.placeId = place.place_id;
    item.innerHTML = `
      <div class="map-results__summary">
        <div class="map-results__info">
          <p class="map-results__name">${place.name}</p>
          <p class="map-results__address">${place.vicinity || ""}</p>
        </div>
        <div class="map-results__meta">
          <div class="map-results__rating-row">${rating}${reviewCount}</div>
          ${status}
        </div>
      </div>
      <div class="map-results__details">
        ${photo}
        <a href="https://www.google.com/maps/place/?q=place_id:${place.place_id}" target="_blank" rel="noopener noreferrer" class="map-results__gmaps-btn" onclick="event.stopPropagation()">
          Ouvrir dans Google Maps
        </a>
      </div>
    `;
    container.appendChild(item);
  });
}

function nearbySearchPromise(service, request) {
  return new Promise(resolve => {
    service.nearbySearch(request, (results, status) => {
      if (status === google.maps.places.PlacesServiceStatus.OK) {
        resolve(results);
      } else {
        resolve([]);
      }
    });
  });
}

function searchNearbyBarsAJeu(map, location) {
  clearMarkers();
  const service = new google.maps.places.PlacesService(map);
  const latLng = new google.maps.LatLng(location.lat, location.lng);
  const keywords = ["bar à jeu", "bar à jeux", "café jeux"];

  Promise.all(keywords.map(keyword =>
    nearbySearchPromise(service, { keyword, location: latLng, radius: 8000 })
  )).then(allResults => {
    const seen = new Set();
    const merged = allResults.flat().filter(place => {
      if (seen.has(place.place_id)) return false;
      seen.add(place.place_id);
      return true;
    });

    if (merged.length === 0) {
      renderResults([]);
      return;
    }

    allPlaces = merged;
    merged.forEach((place, index) => {
        const pawnSvg = `<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
  width="40" height="40" viewBox="0 0 1280 1280"
  preserveAspectRatio="xMidYMid meet">
  <g transform="translate(0,1280) scale(0.1,-0.1)" fill="#2D6A2D" stroke="none">
    <path d="M6183 9760 c-140 -10 -133 5 -134 -279 -1 -130 -4 -246 -7 -259 -5
    -17 -27 -31 -87 -55 -161 -65 -293 -158 -345 -243 -22 -35 -43 -43 -56 -22 -4
    6 -10 127 -14 267 -6 225 -9 260 -25 291 -11 19 -25 66 -31 103 -14 77 -34
    114 -70 127 -38 15 -131 12 -225 -6 -149 -28 -192 -56 -208 -138 -6 -28 -14
    -211 -19 -406 -8 -308 -12 -360 -27 -389 -9 -19 -23 -53 -29 -75 -10 -33 -20
    -46 -58 -66 -61 -34 -88 -58 -105 -98 -23 -56 -3 -104 81 -192 40 -41 83 -90
    96 -108 12 -19 44 -47 70 -63 53 -32 59 -43 90 -155 28 -101 46 -135 125 -242
    174 -234 196 -349 176 -926 -11 -341 -27 -582 -61 -951 -11 -115 -33 -374 -50
    -575 -63 -759 -90 -999 -141 -1258 -62 -321 -108 -472 -190 -632 -79 -152
    -137 -230 -200 -267 -144 -84 -200 -125 -289 -213 -341 -333 -465 -754 -285
    -968 l25 -30 -57 -35 c-66 -40 -123 -97 -147 -144 -24 -47 -31 -143 -16 -198
    45 -162 301 -273 835 -364 679 -116 1795 -143 2660 -66 803 72 1270 209 1356
    399 22 48 25 139 7 198 -16 53 -85 129 -159 174 l-58 36 34 41 c52 61 70 124
    70 247 0 117 -20 196 -80 327 -100 218 -328 463 -528 569 -88 46 -119 80 -200
    214 -182 306 -270 730 -352 1700 -14 168 -37 436 -51 595 -74 860 -84 1026
    -85 1426 -1 201 3 285 15 351 28 150 41 178 209 416 37 53 55 92 78 173 26 92
    34 108 66 134 21 17 55 50 78 74 22 24 73 78 113 119 50 53 75 87 83 115 20
    75 -8 125 -93 168 -32 16 -61 37 -64 47 -3 9 -17 46 -31 82 -25 64 -25 70 -32
    435 -8 413 -10 426 -79 472 -73 48 -320 80 -380 49 -39 -20 -49 -38 -61 -116
    -6 -34 -20 -83 -33 -109 -21 -43 -23 -63 -28 -298 -4 -214 -7 -255 -21 -268
    -15 -15 -18 -14 -37 17 -66 107 -227 213 -424 281 -15 5 -17 32 -20 261 -4
    313 6 294 -149 307 -118 9 -291 9 -426 -1z"/>
  </g>
</svg>`;
        const markerIcon = {
          url: "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(pawnSvg),
          scaledSize: new google.maps.Size(32, 32),
          anchor: new google.maps.Point(16, 32),
        };
        const marker = new google.maps.Marker({
          position: place.geometry.location,
          map: map,
          title: place.name,
          icon: markerIcon,
        });

        currentMarkers.push(marker);
        allMarkersData.push({ place, marker, index });

        marker.addListener("click", () => {
          const container = document.getElementById("map-results");
          const item = container.querySelector(`[data-place-id="${place.place_id}"]`);
          if (item) {
            container.prepend(item);
            item.scrollIntoView({ behavior: "smooth", block: "nearest" });
            expandCard(place.place_id);
          }
        });

        // Clicking a result card pans to the marker and expands it
        document.addEventListener("click", (e) => {
          const item = e.target.closest(`[data-place-id="${place.place_id}"]`);
          if (item) {
            suppressNextIdle = true;
            map.panTo(place.geometry.location);
            map.setZoom(15);
            expandCard(place.place_id);
          }
        });
    });
    filterResultsByBounds(map);
  });
}

function initMap() {
  const defaultCenter = { lat: 48.8566, lng: 2.3522 };
  const userCity = document.getElementById("map").dataset.userCity || null;

  const map = new google.maps.Map(document.getElementById("map"), {
    center: defaultCenter,
    zoom: 13,
    mapTypeControl: false,
    fullscreenControl: false,
    streetViewControl: false,
    rotateControl: false,
    zoomControl: false,
    styles: [
      { featureType: "poi", elementType: "all", stylers: [{ visibility: "off" }] },
      { featureType: "transit", elementType: "labels.icon", stylers: [{ visibility: "off" }] },
    ],
  });

  // Re-filter list when map is panned/zoomed (but not when triggered by a card click)
  map.addListener("idle", () => {
    if (suppressNextIdle) { suppressNextIdle = false; return; }
    if (allMarkersData.length > 0) filterResultsByBounds(map);
  });

  // Search bar
  const input = document.getElementById("map-search-input");
  const clearBtn = document.getElementById("map-search-clear");
  const geocoder = new google.maps.Geocoder();

  input.addEventListener("input", () => {
    clearBtn.style.display = input.value.length > 0 ? "flex" : "none";
  });

  clearBtn.addEventListener("click", () => {
    input.value = "";
    clearBtn.style.display = "none";
    input.focus();
  });

  const geolocateBtn = document.getElementById("map-geolocate-btn");
  geolocateBtn.addEventListener("click", () => {
    if (!navigator.geolocation) return;
    navigator.geolocation.getCurrentPosition(position => {
      const userLocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude,
      };
      map.setCenter(userLocation);
      map.setZoom(13);
      searchNearbyBarsAJeu(map, userLocation);
    });
  });

  input.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      geocoder.geocode({ address: input.value }, (results, status) => {
        if (status === "OK" && results[0]) {
          const location = results[0].geometry.location;
          map.setCenter(location);
          map.setZoom(13);
          searchNearbyBarsAJeu(map, { lat: location.lat(), lng: location.lng() });
        }
      });
    }
  });

  // Initial load
  function loadDefault() {
    if (userCity) {
      geocoder.geocode({ address: userCity }, (results, status) => {
        if (status === "OK" && results[0]) {
          const location = results[0].geometry.location;
          const loc = { lat: location.lat(), lng: location.lng() };
          map.setCenter(loc);
          searchNearbyBarsAJeu(map, loc);
        } else {
          searchNearbyBarsAJeu(map, defaultCenter);
        }
      });
    } else {
      searchNearbyBarsAJeu(map, defaultCenter);
    }
  }

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(position => {
      const userLocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude,
      };
      map.setCenter(userLocation);
      searchNearbyBarsAJeu(map, userLocation);
    }, loadDefault);
  } else {
    loadDefault();
  }
}

window.initMap = initMap;
