import './Home.css';

import { useNavigate } from "react-router-dom";
import { Button } from '@aws-amplify/ui-react';

function Home() {
    const navigate = useNavigate()

    function play() {
      navigate("/play");
    } 

    return (
      <div className="Home">
          <img className="Home-Image" width="478" height="360" alt="Squash the Creeps" src="squash-the-creeps-final.webp"></img>
          <Button className="Home-Button" variation="primary" size="large" onClick={() => play()}>Play</Button>
      </div>
    );
  }
  
  export default Home;