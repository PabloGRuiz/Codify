import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabase";

export function useUser() {
  const [user, setUser] = useState<any>(null);
  const [profile, setProfile] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  const checkAndUpdateStreak = async (userProfile: any) => {
    if (!userProfile) return userProfile;

    try {
      const now = new Date();
      const todayStr = now.toISOString().split("T")[0];
      const lastLoginStr = userProfile.last_login
        ? new Date(userProfile.last_login).toISOString().split("T")[0]
        : null;

      if (lastLoginStr !== todayStr) {
        let newStreak = userProfile.streak_days || 0;

        if (lastLoginStr) {
          const lastDate = new Date(userProfile.last_login);
          // Set to midnight for accurate day comparison
          const todayMidnight = new Date(now.getFullYear(), now.getMonth(), now.getDate());
          const lastMidnight = new Date(lastDate.getFullYear(), lastDate.getMonth(), lastDate.getDate());
          const diffDays = Math.round((todayMidnight.getTime() - lastMidnight.getTime()) / (1000 * 3600 * 24));

          if (diffDays === 1) {
            newStreak += 1;
          } else if (diffDays > 1) {
            newStreak = 1;
          }
        } else {
          newStreak = 1;
        }

        const { data: updatedProfile } = await supabase
          .from("profiles")
          .update({
            streak_days: newStreak,
            last_login: now.toISOString(),
          })
          .eq("id", userProfile.id)
          .select()
          .single();

        return updatedProfile || { ...userProfile, streak_days: newStreak, last_login: now.toISOString() };
      }
    } catch (e) {
      console.error("Error actualizando racha de usuario:", e);
    }

    return userProfile;
  };

  useEffect(() => {
    const fetchUser = async () => {
      try {
        const { data: { session } } = await supabase.auth.getSession();

        if (session?.user) {
          setUser(session.user);
          const { data } = await supabase
            .from("profiles")
            .select("*")
            .eq("id", session.user.id)
            .single();

          if (data) {
            const updated = await checkAndUpdateStreak(data);
            setProfile(updated);
          }
        }
      } catch (err) {
        console.error("Error fetching user data", err);
      } finally {
        setLoading(false);
      }
    };

    fetchUser();

    const { data: authListener } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        if (session?.user) {
          setUser(session.user);
          const { data } = await supabase
            .from("profiles")
            .select("*")
            .eq("id", session.user.id)
            .single();

          if (data) {
            const updated = await checkAndUpdateStreak(data);
            setProfile(updated);
          }
        } else {
          setUser(null);
          setProfile(null);
        }
      }
    );

    return () => {
      authListener.subscription.unsubscribe();
    };
  }, []);

  return { user, profile, loading };
}
