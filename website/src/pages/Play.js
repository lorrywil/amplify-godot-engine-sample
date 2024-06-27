import { useNavigate } from "react-router-dom";
import { Button } from '@aws-amplify/ui-react';
import './Play.css';

function Play() {
  const navigate = useNavigate()

  function home() {
    navigate("/");
  } 

  return (
    <div className="play">
      <iframe className="play-iframe" width="478" height="360" title="Squash the Creeps" src={
        window.location.protocol + "//" + window.location.host + "/game/index.html"}></iframe>
      <Button className="play-button"variation="secondary" size="large" onClick={() => home()}>Home</Button>
    </div>
  );
}

export default Play;
