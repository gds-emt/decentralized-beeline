import React from 'react';
import { web3, Beeline } from '../../../contract/Beeline.sol';
import AccountRow from './AccountRow';

export default function Accounts() {
  return (
    <div className="Web3">
      <h3>Blockchain</h3>
      <dl className="dl-horizontal">
        <dt>Ethereum node</dt>
        <dd>{web3.currentProvider.host}</dd>
        <dt>Latest block</dt>
        <dd>{web3.eth.blockNumber}</dd>
        <dt>Beeline contract</dt>
        <dd>{Beeline.address}</dd>
      </dl>

      <h3>Accounts</h3>
      <table className="table table-hover table-condensed table-striped">
        <thead>
          <tr>
            <th></th>
            <th>Balance</th>
            <th>Withdrawable</th>
            <th>Has tickets</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {web3.eth.accounts.map(
            (account) => <AccountRow key={account} account={account} />
          )}
        </tbody>
      </table>
    </div>
  );
}
