import "./Header.css";

import { Flex, Menu, MenuItem, Image, Link, Heading, View } from "@aws-amplify/ui-react";
import { useNavigate } from "react-router-dom";

const Header = () => {

  const navigate = useNavigate()

  return (
    <View className="header">
      <Flex direction="row" alignItems="center" justifyContent="space-between" className="header-layout">
        <Flex onClick={() => navigate("/")} className="header-left">
          <Image src={process.env.PUBLIC_URL + "/logo.webp"} alt="logo" width={40} height={40}/>
          <Heading level={3}>Squash the Creeps</Heading>
        </Flex>
        <Flex direction="row" alignItems="center" justifyContent="space-between">
          <Flex direction="row" alignItems="center" justifyContent="space-between">
            <Link href="/">Home</Link>
            <Link href="/play">Play</Link>
          </Flex>
          <Menu
            menuAlign="end"
            trigger={
              <View className="header-avatar">
                <img alt="avatar" src={"https://www.w3schools.com/howto/img_avatar.png"}></img>
              </View>
            }
          >
            <MenuItem>Profile</MenuItem>
            <MenuItem>Logout</MenuItem>
          </Menu>
        </Flex>
      </Flex>
    </View>
  )
}

export default Header;