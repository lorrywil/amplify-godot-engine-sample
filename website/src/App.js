import '@aws-amplify/ui-react/styles.css';
import '@fontsource-variable/inter';
import './App.css';

import { Routes, Route } from "react-router-dom";

import { ThemeProvider } from '@aws-amplify/ui-react';
import theme from "./theme";
import Layout from './layout/Layout';
import Home from "./pages/Home";
import Play from "./pages/Play";
import NoPage from "./pages/NoPage";

function App() {
  return (
    <ThemeProvider theme={theme}>
      <Routes>
        <Route path="/game" index></Route>
        <Route path="/" element={<Layout />}>
          <Route index element={<Home />} />
          <Route path="play" element={<Play />} />
          <Route path="*" element={<NoPage />} />
        </Route>
      </Routes>
    </ThemeProvider>
  );
}

export default App;
