# decentralized-beeline
Non-production demo for for Ethereum / Solidity brown bag session: [Beeline](https://www.beeline.sg/)-like decentralized app on Ethereum.

This is only meant as a demo for a tutorial session on Ethereum.

## Features

1. Bus operators are able to submit a route, with a fee and collateral. Fee is paid to dapp owner to for reward and also to combat spam. Collateral acts as a guarantee of sorts that they will deliver the proposed route if a certain occupancy rate is satisfied.

2. Interested customers are able to pre-purchase tickets to routes. Pre-purchased tickets do not instantly transfer values to bus operators but gives operators a guaranteed that tickets have been paid for.

3. If occupancy rate is satisfied, route is deemed to be satisfied. Operators would have to deliver the route, or lose collateral.

4. Commuters are to validate tickets before boarding bus. Validated tickets would transfer the ticket values to the operators.

5. If >= 50% of the sold tickets are validated, collateral is refunded and all sold tickets values are transferred to the bus operators after a holding period, say 3 days.

6. If < 50% of sold tickets are validated, validated tickets' values are transferred to bus operators, unvalidated tickets are refunded, collateral is transferred to dapp owner, after the said holding period.

7. Holding period is to allow arbitrator (dapp owner) to reverse any of the above conditions before settlement occurs.

8. Bus operators are able to cancel a route before it happens. Ticket holders and collateral are refunded.

The features are only meant to demonstrate some basic ideas of a decentralized app and do not cover all potential exploits.

