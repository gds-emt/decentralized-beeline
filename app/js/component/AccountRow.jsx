import React from 'react';
import { Beeline, web3 } from '../../../contract/Beeline.sol';
import DisplayEth from '../helper/DisplayEth.jsx';

const propTypes = {
  account: React.PropTypes.string.isRequired,
};

export default function AccountRow(props) {
  return (
      <tr className="Web3">
        <th>{props.account}</th>
        <td><DisplayEth wei={web3.eth.getBalance(props.account)} /></td>
        <td><DisplayEth wei={Beeline.balances(props.account)} /></td>
        <td>(has tickets)</td>
        <td>
          <button>Add route</button>
          <button>Buy ticket</button>
        </td>
      </tr>
    );
}

AccountRow.propTypes = propTypes;
