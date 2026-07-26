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

### H1 — falsified

Predicted seller handling would drive most of the delay. It doesn't.

| segment | avg days |
|---|---|
| Seller handling | 3.23 |
| Carrier transit | 9.33 |

Splitting by whether the order beat its promised date:

| | orders | avg handling | avg transit |
|---|---|---|---|
| Late | 7,822 | 5.84 | 25.68 |
| On time | 88,482 | 3.00 | 7.89 |

Both segments degrade on late orders, but transit accounts for ~86% of
the excess days. The lever is the carrier, not seller SLA enforcement —
the opposite of what H1 predicted.

**It's a tail problem, not a slow network.** 2,467 of 7,822 late orders
(32%) spent over 30 days in transit; worst was 205 days. Most orders move
fine — a subset gets stuck.

**And it's geographic.** Late rate by destination state:

| state | orders | late | late rate | avg transit when late |
|---|---|---|---|---|
| AL | 397 | 95 | 23.9% | 35.8 |
| MA | 714 | 141 | 19.7% | 30.3 |
| CE | 1,278 | 196 | 15.3% | 38.0 |
| RJ | 12,331 | 1,664 | 13.5% | 31.3 |
| SP | 40441 | 2384 | ~6% | 15.2 |

Northeast states fail 2-4× more often than São Paulo and take twice as
long when they do. RJ is the priority: high volume *and* high failure rate.

## Recommendation
_TBD_
