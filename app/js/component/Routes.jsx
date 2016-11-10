import React from 'react';
import { Beeline } from '../../../contract/Beeline.sol';

class Routes extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      routesCount: Beeline.routesCount().toNumber(),
    };
  }

  render() {
    return (
      <div className="Web3">
        <h3>Routes</h3>

        <p>There are {this.state.routesCount} routes available.</p>
      </div>
    );
  }
}

export default Routes;
