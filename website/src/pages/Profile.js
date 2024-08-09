import { useEffect, useState } from 'react';
import { fetchUserAttributes, updateUserAttributes } from 'aws-amplify/auth';
import { Button, useAuthenticator, Flex, Input, Label, SelectField, View } from '@aws-amplify/ui-react';

const Profile = () => {

  const { user } = useAuthenticator((context) => [context.user]);
  const [avatarName, setAvatarName] = useState("");
  const [avatarColor, setAvatarColor] = useState("");
  const [preferedUserName, setPreferedUserName] = useState("");

  const handleFetchAttributes = async () => {
    const userAttributes = await fetchUserAttributes();

    const existingAvatarName = userAttributes?.["custom:avatar_name"];
    const existingAvatarColor = userAttributes?.["custom:avatar_color"];
    const existingPreferedUserName = userAttributes?.["preferred_username"];

    if (existingAvatarName) setAvatarName(existingAvatarName);
    if (existingAvatarColor) setAvatarColor(existingAvatarColor);
    if (existingPreferedUserName) setPreferedUserName(existingPreferedUserName);

    console.log("userAttributes", userAttributes);
  };

  const handleUpdateUserAttributes = async () => {
    console.log("Current form ", avatarName);
    var userAttributes = {};
    if (avatarName) userAttributes["custom:avatar_name"] = avatarName;
    if (avatarColor) userAttributes["custom:avatar_color"] = avatarColor;
    if (preferedUserName) userAttributes["preferred_username"] = preferedUserName;

    if (Object.keys(userAttributes).length === 0) return;

    var response = await updateUserAttributes({
      userAttributes
    });
    console.log("response update user attributes", response);
  };

  useEffect(() => {
    handleFetchAttributes();
  }, [])

  return (
    <View marginTop={24} direction="column" className="profile">
      <Flex direction="column">
        <Flex direction="column" gap="small">
          <Label htmlFor="small">Username</Label>
          <Input id="small" size="small" width="25%" value={preferedUserName} onChange={(event) => setPreferedUserName(event.target.value)} />
        </Flex>
        <Flex direction="column" gap="small">
          <Label htmlFor="small">Avatar Name</Label>
          <Input id="small" size="small" width="25%" value={avatarName} onChange={(event) => setAvatarName(event.target.value)} />
        </Flex>

        <Flex direction="column" gap="small">
          <SelectField label="Avatar Color" width="25%" value={avatarColor} onChange={(event) => setAvatarColor(event.target.value)}>
            <option value="">-</option>
            <option value="#F94449">Red</option>
            <option value="#4FC3F7">Blue</option>
            <option value="#72BF6A">Green</option>
          </SelectField>
        </Flex>
      </Flex>
      <Button marginTop={24} onClick={handleUpdateUserAttributes} variation='primary'>Update</Button>
    </View>
  );
}

export default Profile;