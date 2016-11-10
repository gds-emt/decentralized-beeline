import React from 'react';
import { web3 } from '../../../contract/Beeline.sol';

const propTypes = {
  account: React.PropTypes.string.isRequired,
};

class AccountRow extends React.Component {
  render() {
    return (
      <tr className="Web3">
        <td>{this.props.account}</td>
        <td>{web3.eth.getBalance(this.props.account).toNumber()}</td>
        <td>(withdrawable)</td>
        <td>(has tickets)</td>
        <td>
          <button>Add route</button>
          <button>Buy ticket</button>
        </td>
      </tr>
    );
  }
}

AccountRow.propTypes = propTypes;

export default AccountRow;
/*
export default function AccountRow() {
//  console.log(this.props);
  return (
    <tr className="Web3">
      {this.props.account}
    </tr>
  );
}
*/
