# Delivery Delay Attribution

**Question:** Late deliveries are hurting reviews and repeat purchase.
Is the failure seller handling or carrier transit, where is it
concentrated, and what is it costing us?

**Stakeholder:** Logistics ops lead at a marketplace with no owned fleet.

## Hypotheses
- **H1** — Handling time (purchase → carrier handover) accounts for more
  than half of total late days, more than transit does.
  *If true:* seller SLA enforcement, not 3PL renegotiation.
- **H2** — Cross-state orders are late ~2× more often than same-state.
  *If true:* distance-adjusted delivery promises.
- **H3** — Late orders score ~2 points lower and cut repeat purchase ~20%.
  *If true:* quantifies the budget ceiling for any fix.

## Data
Olist Brazilian e-commerce, ~100k orders, 2016–2018. 9 tables, Postgres.

## Findings

| segment | avg days |
|---|---|
| Seller handling | 3.23 |
| Carrier transit | 9.33 |

| | orders | avg handling | avg transit |
|---|---|---|---|
| Late | 7,822 | 5.84 | 25.68 |
| On time | 88,482 | 3.00 | 7.89 |
<img width="512" height="117" alt="image" src="https://github.com/user-attachments/assets/dbdbe1ab-0af1-4a72-ba87-0ef62561a810" />

**H1 - false** Handling averages 9.33 days vs 3.23 on the seller side, roughly ~3x 
<img width="980" height="162" alt="image" src="https://github.com/user-attachments/assets/f9b086e3-8bfe-4dbd-8239-618efde217ab" />
Both segments degrade when an order goes late, but transit blows up far harder. Handling adds ~2.8 extra days; transit adds ~17.8. Transit contributes roughly 86% of the excess days on late orders.

## Recommendation
_TBD_
