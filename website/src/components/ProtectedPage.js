import { useAuthenticator } from '@aws-amplify/ui-react';
import { useLocation } from 'react-router-dom';
import { Flex, Text, Button, Placeholder } from "@aws-amplify/ui-react";
import { useNavigate } from 'react-router-dom';
import { useEffect, useState } from 'react'

function ProtectedPage({ children }) {

  const location = useLocation();
  const [isLoading, setIsLoading] = useState(true);

  const navigate = useNavigate();
  const { authStatus } = useAuthenticator((context) => [context.authStatus]);

  useEffect(() => {
    if (authStatus !== 'configuring') {
      setIsLoading(false);
    }
  }, [authStatus]);

  if (authStatus !== 'authenticated') {
    return (
      isLoading ? <Flex direction="column">
        <Placeholder size="small" />
        <Placeholder />
        <Placeholder size="small" />
      </Flex> :
        <Flex direction="column" alignItems="center" justifyContent="flex-start">
          <Text marginTop={24} fontSize={24}>You must be logged in to access this page</Text>
          <Flex marginTop={24} direction="row" alignItems="center" justifyContent="flex-start" gap={32}>
            <Button onClick={() => navigate('/login', { state: { from: location }, replace: true })} variation="primary">Sign In</Button>
            <Button onClick={() => navigate("/login", { state: { from: location }, replace: true })}>Sign Up</Button>
          </Flex>
        </Flex>
    );
  }
  return children;
}

export default ProtectedPage;