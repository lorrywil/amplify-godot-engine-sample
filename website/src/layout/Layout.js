import Header from '../components/Header'
import { View } from '@aws-amplify/ui-react';
import { Outlet } from "react-router-dom";

import "./Layout.css"

const Layout = () => {

  return (
    <View>
      <Header />
      <View className="page-container">
        <Outlet />
      </View>      
    </View>
  )
}

export default Layout;