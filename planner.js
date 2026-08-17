document.addEventListener('DOMContentLoaded', () => {
    let currentStep = 1;
    const totalSteps = 4;

    const steps = document.querySelectorAll('.wizard-step');
    const nodes = document.querySelectorAll('.step-node');
    const nextBtn = document.getElementById('next-btn');
    const prevBtn = document.getElementById('prev-btn');
    const submitBtn = document.getElementById('submit-btn');
    const summaryArea = document.getElementById('summary-area');

    // Input fields
    const pName = document.getElementById('p-name');
    const pType = document.getElementById('p-type');
    const pPlayers = document.getElementById('p-players');
    const pCourts = document.getElementById('p-courts');
    const pHours = document.getElementById('p-hours');
    const pStaff = document.getElementById('p-staff');
    const pCatering = document.getElementById('p-catering');
    const pDate = document.getElementById('p-date');
    const pVenue = document.getElementById('p-venue');
    const pEmail = document.getElementById('p-email');
    const pNotes = document.getElementById('p-notes');

    // Cost Estimator Elements
    const calcTotal = document.getElementById('calc-total');
    const calcBreakdown = document.getElementById('calc-breakdown');

    // Set default date to 2 weeks from now
    if (pDate) {
        const d = new Date();
        d.setDate(d.getDate() + 14);
        pDate.value = d.toISOString().split('T')[0];
    }

    const calculateCost = () => {
        const courts = parseInt(pCourts ? pCourts.value : 4);
        const hours = parseInt(pHours ? pHours.value : 8);
        const players = parseInt(pPlayers ? pPlayers.value : 16) || 16;
        const staff = pStaff ? pStaff.value : 'basic';
        const catering = pCatering ? pCatering.value : 'hydration';
        const venue = pVenue ? pVenue.value : 'Hard Court';

        // 1. Court Cost
        const hourlyRate = courts === 2 ? 50 : courts === 4 ? 90 : 160;
        const courtCost = hourlyRate * hours;

        // 2. Staff Cost
        let staffCost = 0;
        if (staff === 'basic') staffCost = 350;
        if (staff === 'elite') staffCost = 850;

        // 3. Catering Cost
        let cateringCost = 0;
        if (catering === 'hydration') cateringCost = players * 15;
        if (catering === 'vip') cateringCost = players * 45;

        // 4. Venue Premium
        let venueFee = 0;
        if (venue === 'Red Clay') venueFee = 250;
        if (venue === 'Lawn Grass') venueFee = 600;

        const total = courtCost + staffCost + cateringCost + venueFee;

        if (calcTotal) {
            calcTotal.innerText = `$${total.toLocaleString()}`;
        }

        if (calcBreakdown) {
            calcBreakdown.innerHTML = `
                <div class="estimator-row">
                    <span>${courts} Courts (${hours}h @ $${hourlyRate}/h)</span>
                    <strong>$${courtCost.toLocaleString()}</strong>
                </div>
                <div class="estimator-row">
                    <span>Staffing (${staff === 'none' ? 'None' : staff === 'basic' ? '2 Coaches' : 'Elite Master Staff'})</span>
                    <strong>$${staffCost.toLocaleString()}</strong>
                </div>
                <div class="estimator-row">
                    <span>Catering (${players} players)</span>
                    <strong>$${cateringCost.toLocaleString()}</strong>
                </div>
                ${venueFee > 0 ? `
                <div class="estimator-row">
                    <span>${venue} Surface Prep</span>
                    <strong>$${venueFee.toLocaleString()}</strong>
                </div>` : ''}
            `;
        }

        return { total, courtCost, staffCost, cateringCost, venueFee };
    };

    // Attach real-time calculation listeners
    [pCourts, pHours, pPlayers, pStaff, pCatering, pVenue].forEach(el => {
        if (el) {
            el.addEventListener('input', calculateCost);
            el.addEventListener('change', calculateCost);
        }
    });

    calculateCost();

    const validateStep = (step) => {
        if (step === 1) {
            if (!pName.value.trim()) {
                if (window.showToast) window.showToast('Please enter an event title.', 'error');
                pName.focus();
                return false;
            }
            if (!pPlayers.value || parseInt(pPlayers.value) <= 0) {
                if (window.showToast) window.showToast('Please enter a valid player count.', 'error');
                pPlayers.focus();
                return false;
            }
        }
        if (step === 3) {
            if (!pDate.value) {
                if (window.showToast) window.showToast('Please select a target date.', 'error');
                pDate.focus();
                return false;
            }
        }
        return true;
    };

    const updateWizard = () => {
        // Update steps visibility
        steps.forEach(step => step.classList.remove('active'));
        const activeStepEl = document.getElementById(`step-${currentStep}`);
        if (activeStepEl) activeStepEl.classList.add('active');

        // Update progress nodes
        nodes.forEach(node => {
            const stepNum = parseInt(node.dataset.step);
            node.classList.remove('active', 'completed');
            if (stepNum === currentStep) node.classList.add('active');
            if (stepNum < currentStep) node.classList.add('completed');
        });

        // Update buttons
        prevBtn.style.display = currentStep === 1 ? 'none' : 'block';
        if (currentStep === totalSteps) {
            nextBtn.style.display = 'none';
            submitBtn.style.display = 'block';
            generateSummary();
        } else {
            nextBtn.style.display = 'block';
            submitBtn.style.display = 'none';
        }
    };

    const generateSummary = () => {
        const { total } = calculateCost();
        const data = {
            name: pName.value || 'Untitled Event',
            type: pType.value,
            players: pPlayers.value || '16',
            courts: pCourts.value,
            hours: pHours.value,
            staff: pStaff.options[pStaff.selectedIndex].text,
            catering: pCatering.options[pCatering.selectedIndex].text,
            date: pDate.value ? new Date(pDate.value).toLocaleDateString(undefined, { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric' }) : 'TBD',
            venue: pVenue.options[pVenue.selectedIndex].text
        };

        summaryArea.innerHTML = `
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; font-size: 0.95rem;">
                <div><strong style="color: var(--primary-green);">Event:</strong> ${data.name}</div>
                <div><strong style="color: var(--primary-green);">Category:</strong> ${data.type}</div>
                <div><strong style="color: var(--primary-green);">Players:</strong> ${data.players} Players</div>
                <div><strong style="color: var(--primary-green);">Duration:</strong> ${data.hours} Hours</div>
                <div><strong style="color: var(--primary-green);">Facility:</strong> ${data.courts} Courts (${data.venue})</div>
                <div><strong style="color: var(--primary-green);">Staffing:</strong> ${data.staff}</div>
                <div><strong style="color: var(--primary-green);">Catering:</strong> ${data.catering}</div>
                <div><strong style="color: var(--primary-green);">Estimated Total:</strong> <span style="color: var(--primary-green); font-weight: 800; font-size: 1.1rem;">$${total.toLocaleString()}</span></div>
                <div style="grid-column: 1 / span 2; border-top: 1px solid #e0eae0; padding-top: 1rem; margin-top: 0.5rem; color: var(--secondary-green); font-weight: 700;">
                    Scheduled Date: ${data.date}
                </div>
            </div>
        `;
    };

    nextBtn.addEventListener('click', () => {
        if (!validateStep(currentStep)) return;
        if (currentStep < totalSteps) {
            currentStep++;
            updateWizard();
            calculateCost();
        }
    });

    prevBtn.addEventListener('click', () => {
        if (currentStep > 1) {
            currentStep--;
            updateWizard();
            calculateCost();
        }
    });

    const plannerForm = document.getElementById('multi-step-planner');
    if (plannerForm) {
        plannerForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const { total } = calculateCost();

            const plan = {
                title: pName.value,
                type: pType.value,
                players: pPlayers.value,
                courts: pCourts.value,
                hours: pHours.value,
                staff: pStaff.value,
                catering: pCatering.value,
                date: pDate.value,
                venue: pVenue.value,
                email: pEmail.value,
                notes: pNotes ? pNotes.value : '',
                estimatedBudget: `$${total.toLocaleString()}`,
                status: 'Under Review'
            };

            if (window.WildCardDB) {
                window.WildCardDB.savePlan(plan);
            }

            if (window.showToast) {
                window.showToast('Strategic Proposal Submitted! Proposal saved to your dashboard.', 'success', 4000);
            }

            setTimeout(() => {
                window.location.href = 'account.html#events';
            }, 1200);
        });
    }
});
