import './Layout.css';

import { Menu, MenuItem } from '@aws-amplify/ui-react';
import { Outlet, useNavigate } from "react-router-dom";
import Logo from "./Logo";
import Title from "./Title";

const Layout = () => {
  const navigate = useNavigate()

  function home() {
    navigate("/");
  } 

  function play() {
    navigate("/play");
  } 

  return (
    <>
      <nav class="Layout">
        <Logo />
        <Title />
        <div class="Layout-Filler"></div>
        <Menu>
          <MenuItem onClick={() => home()}>Home</MenuItem>
          <MenuItem onClick={() => play()}>Play</MenuItem>
        </Menu>
      </nav>

      <Outlet />
    </>
  )
};

export default Layout;
