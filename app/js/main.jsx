import 'babel-polyfill';
import React from 'react';
import { render } from 'react-dom';

import '../less/app.less';
import App from './component/App';

render(
  <App />,
  document.getElementById('root')
);
