document.addEventListener('DOMContentLoaded', () => {
    let currentStep = 1;
    const totalSteps = 4;

    const steps = document.querySelectorAll('.wizard-step');
    const nodes = document.querySelectorAll('.step-node');
    const nextBtn = document.getElementById('next-btn');
    const prevBtn = document.getElementById('prev-btn');
    const submitBtn = document.getElementById('submit-btn');
    const summaryArea = document.getElementById('summary-area');

    const updateWizard = () => {
        // Update steps visibility
        steps.forEach(step => step.classList.remove('active'));
        document.getElementById(`step-${currentStep}`).classList.add('active');

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
        const data = {
            name: document.getElementById('p-name').value,
            type: document.getElementById('p-type').value,
            players: document.getElementById('p-players').value,
            courts: document.getElementById('p-courts').value,
            staff: document.getElementById('p-staff').value,
            catering: document.getElementById('p-catering').value,
            date: document.getElementById('p-date').value,
            venue: document.getElementById('p-venue').value
        };

        summaryArea.innerHTML = `
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div><strong>Event:</strong> ${data.name}</div>
                <div><strong>Type:</strong> ${data.type}</div>
                <div><strong>Players:</strong> ${data.players || 'N/A'}</div>
                <div><strong>Facility:</strong> ${data.courts} Courts (${data.venue})</div>
                <div><strong>Staffing:</strong> ${data.staff}</div>
                <div><strong>Catering:</strong> ${data.catering}</div>
                <div style="grid-column: 1 / span 2; border-top: 1px solid #ddd; padding-top: 1rem; margin-top: 0.5rem;">
                    <strong>Scheduled Date:</strong> ${data.date || 'To be determined'}
                </div>
            </div>
        `;
    };

    nextBtn.addEventListener('click', () => {
        if (currentStep < totalSteps) {
            currentStep++;
            updateWizard();
        }
    });

    prevBtn.addEventListener('click', () => {
        if (currentStep > 1) {
            currentStep--;
            updateWizard();
        }
    });

    document.getElementById('multi-step-planner').addEventListener('submit', (e) => {
        e.preventDefault();
        alert('Strategic Plan Received. Our Venue Director will prepare a quote and contact you shortly.');
        window.location.href = 'index.html';
    });
});
