/**
 * Single source of truth for public event listings.
 * Used by index.html (#events-list) and events.html (#events-directory).
 */
window.WildCardEvents = [
    {
        id: 'masters-mt1000-nairobi',
        title: 'Masters MT1000 Nairobi',
        tag: 'Official Masters Event',
        poster: 'assets/masters-mt1000-nairobi-poster.jpeg',
        posterAlt: 'Official Masters MT1000 Nairobi tournament poster',
        legs: [
            { label: 'First Leg', dates: '16–18 November 2026' },
            { label: 'Second Leg', dates: '19–21 November 2026' }
        ],
        venue: '254 Racquet Club, Loresho Ridge, Nairobi, Kenya',
        description: 'The first of its kind in East Africa. A prestigious masters tennis tournament organised in collaboration with 254 Racquet Club, World Tennis Masters, Wild Card Tennis and Tennis Kenya.',
        ageCategories: ['35+', '40+', '45+', '50+', '55+', '60+', '65+'],
        eventCategories: ["Men's Singles", "Women's Singles", "Men's Doubles", "Women's Doubles", 'Mixed Doubles'],
        fees: [
            { label: 'Singles', price: 'USD 30' },
            { label: 'Doubles', price: 'USD 25' },
            { label: 'Mixed Doubles', price: 'USD 25' },
            { label: 'IPIN (per event)', price: 'USD 12' }
        ],
        deadline: 'Tuesday, 10 November 2026',
        registrationUrl: 'https://tourzone.world.tennis/'
    }
];

/**
 * Builds the HTML for a tournament card.
 * @param {object} ev - event object from window.WildCardEvents
 * @param {{detailed?: boolean}} [opts]
 */
window.renderTournamentCard = function (ev, opts) {
    const detailed = !!(opts && opts.detailed);
    const chips = (arr) => arr.map(c => `<span class="chip">${c}</span>`).join('');
    const link = `href="${ev.registrationUrl}" target="_blank" rel="noopener noreferrer"`;

    const extra = detailed ? `
        <div class="tournament-detail-group">
            <h4>Age Categories</h4>
            <div class="chip-row">${chips(ev.ageCategories)}</div>
        </div>
        <div class="tournament-detail-group">
            <h4>Event Categories</h4>
            <div class="chip-row">${chips(ev.eventCategories)}</div>
        </div>
        <div class="tournament-detail-group">
            <h4>Entry Fees</h4>
            <ul class="fee-list">
                ${ev.fees.map(f => `<li><span>${f.label}</span><strong>${f.price}</strong></li>`).join('')}
            </ul>
        </div>` : '';

    return `
        <article class="event-card tournament-card${detailed ? ' tournament-card--detailed' : ''}">
            <a class="tournament-poster" ${link} aria-label="Register for ${ev.title} (opens in a new tab)">
                <img src="${ev.poster}" alt="${ev.posterAlt}" loading="lazy">
            </a>
            <div class="event-content tournament-body">
                <span class="event-tag">${ev.tag}</span>
                <h3>${ev.title}</h3>
                <div class="tournament-legs">
                    ${ev.legs.map(l => `<div><span>${l.label}</span><strong>${l.dates}</strong></div>`).join('')}
                </div>
                <p class="tournament-venue"><svg class="pin-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5a2.5 2.5 0 1 1 0-5 2.5 2.5 0 0 1 0 5z"/></svg>${ev.venue}</p>
                <p class="tournament-desc">${ev.description}</p>
                ${extra}
                <p class="tournament-deadline">Entry deadline: <strong>${ev.deadline}</strong></p>
                <a class="cta-button tournament-register" ${link}>Register Now</a>
            </div>
        </article>`;
};

/**
 * Builds the homepage cover (hero) feature for the headline tournament.
 * @param {object} ev - event object from window.WildCardEvents
 */
window.renderFeaturedHero = function (ev) {
    if (!ev) return '';
    const link = `href="${ev.registrationUrl}" target="_blank" rel="noopener noreferrer"`;
    return `
        <div class="hero-feature-text">
            <p class="hero-eyebrow">Featured Tournament &middot; ${ev.tag}</p>
            <h1>${ev.title.replace('MT1000', '<span>MT1000</span>')}</h1>
            <p class="hero-tagline">The first of its kind in East Africa.</p>
            <div class="hero-legs">
                ${ev.legs.map(l => `<div><span>${l.label}</span><strong>${l.dates}</strong></div>`).join('')}
            </div>
            <p class="hero-venue"><svg class="pin-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5a2.5 2.5 0 1 1 0-5 2.5 2.5 0 0 1 0 5z"/></svg>${ev.venue}</p>
            <div class="hero-actions">
                <a class="cta-button" ${link}>Register Now</a>
                <a class="cta-button cta-outline" href="#events">Full Details</a>
            </div>
            <p class="hero-deadline">Entry deadline: <strong>${ev.deadline}</strong></p>
        </div>
        <a class="hero-poster" ${link} aria-label="Register for ${ev.title} (opens in a new tab)">
            <img src="${ev.poster}" alt="${ev.posterAlt}" fetchpriority="high">
        </a>`;
};
