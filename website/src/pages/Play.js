import './Play.css';

function Play() {
  return (
    <div class="Play">
      <iframe width="500" height="400" title="Squash the Creeps" src={
window.location.protocol + "//" + window.location.host + "/game/index.html"}></iframe>
    </div>
  );
}

export default Play;
