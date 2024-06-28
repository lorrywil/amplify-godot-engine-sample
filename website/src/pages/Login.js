import { Authenticator, View } from '@aws-amplify/ui-react';
import { useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { useAuthenticator } from '@aws-amplify/ui-react';

function Login() {

  const { authStatus } = useAuthenticator((context) => [context.authStatus]);

  const location = useLocation();
  const navigate = useNavigate();
  const from = location.state?.from?.pathname || '/';

  useEffect(() => {
    console.log('authStatus trigger ', authStatus);
    if(authStatus === 'authenticated') navigate(from, { replace: true });
  }, [authStatus, navigate, from]);

  return (
    <View marginTop={48}>
      <Authenticator>
      </Authenticator>
    </View>
  );
}

export default Login;
