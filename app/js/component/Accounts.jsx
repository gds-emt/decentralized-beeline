import React from 'react';
import { web3, Beeline } from '../../../contract/Beeline.sol';
import AccountRow from './AccountRow';

export default function Accounts() {
  return (
    <div className="Web3">
      <h3>Accounts</h3>
      <table>
        <tr>
          <th></th>
          <th>Balance</th>
          <th>Withdrawable</th>
          <th>Has tickets</th>
          <th></th>
        </tr>

          {web3.eth.accounts.map(
            (account) => <AccountRow key={account} account={account} />
          )}
      </table>

      <h3>Blockchain</h3>
      <dl>
        <dt>Connected Ethereum node (Web3 provider)</dt>
        <dd>{web3.currentProvider.host}</dd>
        <dt>Latest block</dt>
        <dd>{web3.eth.blockNumber}</dd>
        <dt>Beeline contract address</dt>
        <dd>{Beeline.address}</dd>
      </dl>
    </div>
  );
}
