<script setup lang="ts"></script>

<template>
    <svg
        viewBox="0 0 620 500"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        class="size-full"
    >
        <defs>
            <linearGradient
                id="hero-bg"
                x1="40"
                y1="20"
                x2="580"
                y2="480"
                gradientUnits="userSpaceOnUse"
            >
                <stop stop-color="#E0E7FF" />
                <stop offset="0.55" stop-color="#C7D2FE" />
                <stop offset="1" stop-color="#EEF2FF" />
            </linearGradient>
            <linearGradient id="hero-indigo" x1="0" y1="0" x2="1" y2="1">
                <stop stop-color="#4F46E5" />
                <stop offset="1" stop-color="#3730A3" />
            </linearGradient>
            <linearGradient id="hero-blue" x1="0" y1="0" x2="1" y2="1">
                <stop stop-color="#818CF8" />
                <stop offset="1" stop-color="#4338CA" />
            </linearGradient>
            <linearGradient id="hero-accent" x1="0" y1="0" x2="1" y2="1">
                <stop stop-color="#93C5FD" />
                <stop offset="1" stop-color="#1D4ED8" />
            </linearGradient>
            <filter
                id="hero-shadow"
                x="-30%"
                y="-30%"
                width="160%"
                height="170%"
            >
                <feDropShadow
                    dx="0"
                    dy="14"
                    stdDeviation="16"
                    flood-color="#1E1B4B"
                    flood-opacity="0.13"
                />
            </filter>
            <filter
                id="hero-shadow-sm"
                x="-30%"
                y="-30%"
                width="160%"
                height="170%"
            >
                <feDropShadow
                    dx="0"
                    dy="7"
                    stdDeviation="9"
                    flood-color="#312E81"
                    flood-opacity="0.12"
                />
            </filter>
        </defs>

        <rect width="620" height="500" rx="36" fill="url(#hero-bg)" />
        <circle cx="540" cy="72" r="74" fill="#C7D2FE" opacity="0.45" />
        <circle cx="70" cy="430" r="96" fill="#C7D2FE" opacity="0.35" />
        <path
            d="M40 90h44M62 68v44"
            stroke="#A5B4FC"
            stroke-width="4"
            stroke-linecap="round"
        />
        <path
            d="M556 396h32M572 380v32"
            stroke="#93C5FD"
            stroke-width="4"
            stroke-linecap="round"
        />
        <circle cx="82" cy="106" r="6" fill="#FBBF24" />
        <circle cx="548" cy="152" r="5" fill="#818CF8" />
        <circle cx="112" cy="360" r="4" fill="#818CF8" />

        <!-- Back card: idea board -->
        <g filter="url(#hero-shadow)" transform="rotate(-6 200 190)">
            <rect
                x="62"
                y="92"
                width="238"
                height="196"
                rx="20"
                fill="#FFFFFF"
            />
            <rect
                x="62"
                y="92"
                width="238"
                height="46"
                rx="20"
                fill="#EEF2FF"
            />
            <circle cx="86" cy="115" r="5" fill="#F87171" />
            <circle cx="102" cy="115" r="5" fill="#FBBF24" />
            <circle cx="118" cy="115" r="5" fill="#818CF8" />
            <rect
                x="84"
                y="158"
                width="118"
                height="10"
                rx="5"
                fill="#C7D2FE"
            />
            <rect x="84" y="180" width="176" height="8" rx="4" fill="#E2E8F0" />
            <rect x="84" y="200" width="146" height="8" rx="4" fill="#E2E8F0" />
            <rect
                x="84"
                y="228"
                width="72"
                height="36"
                rx="10"
                fill="url(#hero-indigo)"
            />
            <rect
                x="166"
                y="228"
                width="72"
                height="36"
                rx="10"
                fill="#EEF2FF"
            />
            <rect x="180" y="241" width="44" height="8" rx="4" fill="#A5B4FC" />
        </g>

        <!-- Chat bubble -->
        <g filter="url(#hero-shadow-sm)">
            <rect
                x="300"
                y="66"
                width="164"
                height="76"
                rx="20"
                fill="#FFFFFF"
            />
            <path d="M330 142l-8 20 28-20h-20z" fill="#FFFFFF" />
            <circle cx="332" cy="96" r="14" fill="url(#hero-accent)" />
            <rect x="356" y="88" width="88" height="8" rx="4" fill="#CBD5E1" />
            <rect x="356" y="104" width="64" height="8" rx="4" fill="#E2E8F0" />
        </g>

        <!-- Main laptop / workspace -->
        <g filter="url(#hero-shadow)">
            <rect
                x="176"
                y="188"
                width="292"
                height="186"
                rx="18"
                fill="#312E81"
            />
            <rect
                x="188"
                y="200"
                width="268"
                height="160"
                rx="10"
                fill="#FFFFFF"
            />
            <rect
                x="188"
                y="200"
                width="268"
                height="30"
                rx="10"
                fill="#FFFFFF"
            />
            <circle cx="206" cy="215" r="4" fill="#F87171" />
            <circle cx="220" cy="215" r="4" fill="#FBBF24" />
            <circle cx="234" cy="215" r="4" fill="#818CF8" />
            <rect
                x="204"
                y="246"
                width="96"
                height="10"
                rx="5"
                fill="url(#hero-indigo)"
            />
            <rect
                x="204"
                y="266"
                width="180"
                height="8"
                rx="4"
                fill="#E2E8F0"
            />
            <rect
                x="204"
                y="284"
                width="144"
                height="8"
                rx="4"
                fill="#E2E8F0"
            />
            <rect
                x="204"
                y="308"
                width="70"
                height="34"
                rx="9"
                fill="#EEF2FF"
            />
            <rect
                x="282"
                y="308"
                width="70"
                height="34"
                rx="9"
                fill="#EEF2FF"
            />
            <circle
                cx="414"
                cy="292"
                r="30"
                fill="url(#hero-blue)"
                opacity="0.16"
            />
            <path
                d="M402 292l9 9 17-19"
                stroke="#4338CA"
                stroke-width="5"
                stroke-linecap="round"
                stroke-linejoin="round"
            />
            <path d="M150 374h344l24 30H126l24-30z" fill="#CBD5E1" />
            <path
                d="M126 404h392v12a8 8 0 0 1-8 8H134a8 8 0 0 1-8-8v-12z"
                fill="#94A3B8"
            />
        </g>

        <!-- Person 1 (left) -->
        <g>
            <path
                d="M78 468c0-46 26-78 62-78s62 32 62 78"
                fill="url(#hero-indigo)"
            />
            <circle cx="140" cy="356" r="34" fill="#E0E7FF" />
            <path
                d="M107 352c0-24 14-40 33-40 20 0 35 15 35 38-8-12-20-16-34-16-13 0-24 6-34 18z"
                fill="#1E1B4B"
            />
            <circle cx="128" cy="358" r="2.5" fill="#1E1B4B" />
            <circle cx="152" cy="358" r="2.5" fill="#1E1B4B" />
            <path
                d="M132 372c5 4 11 4 16 0"
                stroke="#1E1B4B"
                stroke-width="2.5"
                stroke-linecap="round"
            />
        </g>

        <!-- Person 2 (right) -->
        <g>
            <path
                d="M356 468c0-42 24-72 58-72s58 30 58 72"
                fill="url(#hero-blue)"
            />
            <circle cx="414" cy="368" r="31" fill="#C7D2FE" />
            <path
                d="M384 366c0-22 13-36 30-36 18 0 31 13 31 34-9-10-19-14-31-14-11 0-21 5-30 16z"
                fill="#312E81"
            />
            <circle cx="404" cy="370" r="2.5" fill="#312E81" />
            <circle cx="425" cy="370" r="2.5" fill="#312E81" />
            <path
                d="M407 382c5 4 11 4 16 0"
                stroke="#1E1B4B"
                stroke-width="2.5"
                stroke-linecap="round"
            />
        </g>

        <!-- Floating badges -->
        <g filter="url(#hero-shadow-sm)">
            <rect
                x="418"
                y="150"
                width="132"
                height="52"
                rx="16"
                fill="#FFFFFF"
            />
            <circle cx="446" cy="176" r="14" fill="#E0E7FF" />
            <path
                d="M440 176l4 4 8-9"
                stroke="#4338CA"
                stroke-width="3"
                stroke-linecap="round"
                stroke-linejoin="round"
            />
            <rect
                x="470"
                y="168"
                width="62"
                height="7"
                rx="3.5"
                fill="#CBD5E1"
            />
            <rect
                x="470"
                y="182"
                width="40"
                height="7"
                rx="3.5"
                fill="#E2E8F0"
            />
        </g>
        <g filter="url(#hero-shadow-sm)" transform="rotate(7 92 254)">
            <rect
                x="34"
                y="232"
                width="118"
                height="48"
                rx="16"
                fill="#FFFFFF"
            />
            <circle cx="62" cy="256" r="13" fill="#E0E7FF" />
            <path
                d="M56 256h12M62 250v12"
                stroke="#1E1B4B"
                stroke-width="3"
                stroke-linecap="round"
            />
            <rect
                x="86"
                y="248"
                width="52"
                height="7"
                rx="3.5"
                fill="#CBD5E1"
            />
            <rect
                x="86"
                y="262"
                width="36"
                height="7"
                rx="3.5"
                fill="#E2E8F0"
            />
        </g>
    </svg>
</template>
