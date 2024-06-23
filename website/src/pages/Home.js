import './Home.css';

import { Link } from "react-router-dom";

function Home() {
    return (
      <div className="Home">
        <header className="Home-header">
          <p>
            Squash the Creeps
          </p>
          <img width="500" height="400" alt="Squash the Creeps" src="squash-the-creeps-final.webp"></img>
          <br></br>
          <Link to="/play" className="Home-link">Play</Link>
        </header>
      </div>
    );
  }
  
  export default Home;