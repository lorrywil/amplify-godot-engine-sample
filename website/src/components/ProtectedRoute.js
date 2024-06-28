import { useAuthenticator } from '@aws-amplify/ui-react';
import { Navigate, useLocation } from 'react-router-dom';
import { Flex, Placeholder } from "@aws-amplify/ui-react";
import { useEffect, useState } from 'react'

function ProtectedRoute({ children }) {

  const location = useLocation();
  const { authStatus } = useAuthenticator((context) => [context.authStatus]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    if (authStatus !== 'configuring') {
      setIsLoading(false);
    }
  }, [authStatus]);

  if (isLoading) {
    // You can render a loading spinner or any other loading indicator here
    return (
      <Flex direction="column">
        <Placeholder size="small" />
        <Placeholder />
        <Placeholder size="small" />
      </Flex>);
  }
  else if (authStatus !== 'authenticated') {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }
  return children;
}

export default ProtectedRoute;